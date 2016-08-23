#!/bin/bash

# Copyright 2014 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Bring up a Kubernetes cluster.
#
# If the full release name (gs://<bucket>/<release>) is passed in then we take
# that directly.  If not then we assume we are doing development stuff and take
# the defaults in the release config.

## 遇到错误，就退出脚本，作用同set -e
set -o errexit
## 遇到unset的环境变量就报错退出
set -o nounset
## 管道命令失败就返回非0值
set -o pipefail

## BASH_SOURCE环境变量是一个数组，这里读取数组的第一个元素，也就是执行该脚本时的路径命
KUBE_ROOT=$(dirname "${BASH_SOURCE}")/..
## ${TXT:-txt} ，这里是${}中:-的用法，即：如果TXT不存在，就用txt字符串代替他
## 忽略安装中的非致命错误
EXIT_ON_WEAK_ERROR="${EXIT_ON_WEAK_ERROR:-false}"

if [ -f "${KUBE_ROOT}/cluster/env.sh" ]; then
    source "${KUBE_ROOT}/cluster/env.sh"
fi

## 引入kube_server_version函数
source "${KUBE_ROOT}/cluster/kube-env.sh"
## 引入validate-cluster等函数, 函数的具体实现，是在cluster/KUBERNETES_PROVIDER/util.sh中，它会覆盖原先kube-util.sh中的所有函数
source "${KUBE_ROOT}/cluster/kube-util.sh"


## ${ZONE-}中-的意思是：如果变量ZONE未定义, 则替换为-之后的内容，此处为空；若变量已定义却是空的，也不替换。
if [ -z "${ZONE-}" ]; then
  ## KUBERNETES_PROVIDER由kube-env.sh引入, 缺省值为gce
  echo "... Starting cluster using provider: ${KUBERNETES_PROVIDER}" >&2
else
  echo "... Starting cluster in ${ZONE} using provider ${KUBERNETES_PROVIDER}" >&2
fi

## 从kube-util.sh中引入,
echo "... calling verify-prereqs" >&2
verify-prereqs

## 无脚本引入，所以是看环境变量中是否定义
if [[ "${KUBE_STAGE_IMAGES:-}" == "true" ]]; then
  echo "... staging images" >&2
  ## ubuntu/util.sh中的kube-up函数引入了common.sh，其中包含了stage-images函数
  stage-images
fi

## ubuntu/util.sh中引入了kube-up函数
echo "... calling kube-up" >&2
kube-up

## validate-cluster函数从kube-util.sh引入，但没有被util.sh重写，最终将调用validate-cluster.sh脚本
echo "... calling validate-cluster" >&2
# Override errexit
(validate-cluster) && validate_result="$?" || validate_result="$?"

# We have two different failure modes from validate cluster:
# - 1: fatal error - cluster won't be working correctly
# - 2: weak error - something went wrong, but cluster probably will be working correctly
# We always exit in case 1), but if EXIT_ON_WEAK_ERROR != true, then we don't fail on 2).
if [[ "${validate_result}" == "1" ]]; then
	exit 1
elif [[ "${validate_result}" == "2" ]]; then
	if [[ "${EXIT_ON_WEAK_ERROR}" == "true" ]]; then
		exit 1;
	else
		echo "...ignoring non-fatal errors in validate-cluster" >&2
	fi
fi

echo -e "Done, listing cluster services:\n" >&2
"${KUBE_ROOT}/cluster/kubectl.sh" cluster-info
echo

exit 0
