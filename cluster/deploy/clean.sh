#!/bin/bash

/etc/init.d/etcd stop

rm -rf \
  /opt/bin/etcd* \
  /etc/init/etcd.conf \
  /etc/init.d/etcd \
  /etc/default/etcd

rm -rf /infra*
rm -rf /srv/kubernetes


/etc/init.d/flanneld stop
rm -rf /var/lib/kubelet


/etc/init.d/kube-apiserver stop
/etc/init.d/kube-controller-manager stop
/etc/init.d/kubelet stop
/etc/init.d/kube-proxy stop
/etc/init.d/kube-scheduler stop

rm -f \
  /opt/bin/kube* \
  /opt/bin/flanneld \
  /etc/init/kube* \
  /etc/init/flanneld.conf \
  /etc/init.d/kube* \
  /etc/init.d/flanneld \
  /etc/default/kube* \
  /etc/default/flanneld

rm -rf ~/kube
rm -f /run/flannel/subnet.env

echo "clean binaries"
rm -rf ubuntu/binaries
