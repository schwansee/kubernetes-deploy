#!/bin/bash

if [ -f /etc/hosts.gcr && -f /etc/hosts.bak ]; then 
  sudo cp /etc/hosts{.bak,}
fi
