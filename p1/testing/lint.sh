#!/usr/bin/env bash

cd "$REPO_DIR/nhsapp/web" || { echo "Invalid directory $REPO_DIR/nhsapp/web" && exit 1; }
npm run lint

cd $REPO_DIR/nhsapp/automation-test/web || { echo "Invalid directory $REPO_DIR/nhsapp/automation-test/web" && exit 1; }
npm run format:check
