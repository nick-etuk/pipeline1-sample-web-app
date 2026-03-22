#!/usr/bin/env bash

cp /etc/hosts /var/tmp/hosts.bak
cat "$P1_ROOT_UNIX/core/lib/conf/hosts.txt" >> /etc/hosts
