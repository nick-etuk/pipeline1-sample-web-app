#!/usr/bin/env bash
fix_nuget_filename() {
  local buildscripts_dir
  local bad_filename
  local good_filename

  buildscripts_dir="$REPO_DIR"/nhsapp/buildscripts
  bad_filename="$buildscripts_dir"/package_feeds/Nuget.config
  good_filename="$buildscripts_dir"/package_feeds/NuGet.Config

  if [ -f "$bad_filename" ]; then
    mv "$bad_filename" "$good_filename"
    warn "Fixed capitalisation of NuGet.Config in $buildscripts_dir/package_feeds"
  fi
}


configure_package_feed() {
  local buildscripts_dir
  local email
  local pat
  
  buildscripts_dir="$REPO_DIR"/nhsapp/buildscripts
  fix_nuget_filename

  email="$P1_USER_WIN@hscic.gov.uk"
  pat=$(cat "$WORKING_DIR/.pat")

  "$buildscripts_dir"/configure_package_feed.sh "$pat" "$email"

  fix_nuget_filename
}

configure_package_feed
