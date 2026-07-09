#!/usr/bin/env bash

DOTNET_MAJOR_VERSION=5

sudo apt-get update
sudo apt-get install -y "dotnet-sdk-$DOTNET_MAJOR_VERSION.0"
