#!/usr/bin/env bash

cp /etc/hosts /var/tmp/hosts.bak
cat "$WS_ROOT_UNIX/core/lib/conf/hosts.txt" >> /etc/hosts
