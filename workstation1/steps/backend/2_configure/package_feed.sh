#!/usr/bin/env bash

package_feed() {
  local buildscripts_dir
  local bad_filename
  local good_filename
  local email
  local pat
  
  buildscripts_dir="$REPO_DIR"/nhsapp/buildscripts
  bad_filename="$buildscripts_dir"/package_feeds/Nuget.config
  good_filename="$buildscripts_dir"/package_feeds/NuGet.Config

  if [ -f "$bad_filename" ]; then
    mv "$bad_filename" "$good_filename"
    warn "Fixed capitalisation of NuGet.Config in $buildscripts_dir/package_feeds"
  fi

  email="$WINDOWS_USER@hscic.gov.uk"
  pat=$(cat "$WORKING_DIR/.pat")
  debug "=>package_feed.sh"
  debug "pat: $pat"
  debug "email: $email"

  "$buildscripts_dir"/configure_package_feed.sh "$pat" "$email"

  bad_filename="$HOME/.nuget/NuGet/NuGet.config"
  good_filename="$HOME/.nuget/NuGet/NuGet.Config"

  if [ -f "$bad_filename" ]; then
    cp "$bad_filename" "$good_filename"
    warn "Fixed capitalisation of NuGet.Config in $HOME/.nuget/NuGet"
  fi
}
package_feed