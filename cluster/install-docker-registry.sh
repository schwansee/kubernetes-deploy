#!/bin/bash

sudo docker run -d -p 5000:5000 --restart=always --name registry registry:2

## To stop registry
#sudo docker stop registry && docker rm -v registry
