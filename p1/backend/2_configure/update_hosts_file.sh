#!/usr/bin/env bash

cp /etc/hosts /var/tmp/hosts.bak
script_dir="$(dirname "$(realpath "$0")")"
cat "$script_dir/web_hosts.txt" >> /etc/hosts
