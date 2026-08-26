#!/usr/bin/env bash

cd $REPO_DIR/nhsapp/automation-test/web || { echo "Invalid directory $REPO_DIR/nhsapp/automation-test/web" && exit 1; }
# npm ci
npm run format:check
# npx playwright test --project=web-desktop
# WORKERS=4 ./automation-test/web/buildscripts/01_run_component_test.sh
WORKERS=4 ./buildscripts/01_run_component_test.sh
