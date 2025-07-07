#!/usr/bin/env bash

switch_to "$REPO_DIR/nhsapp-ios"
npm install
npm run generate-nhsapi

switch_back
