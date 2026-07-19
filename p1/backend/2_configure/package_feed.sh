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

preconfigured_files() {
  [ -z "$WORKING_DIR_ONEDRIVE" ] && return 1

  if [ -f "$WORKING_DIR_ONEDRIVE/.pat" ] && [ "$WORKING_DIR_ONEDRIVE/.pat" -nt "$WORKING_DIR/.pat" ]; then
    info "Copying newer Personal Access Token from $WORKING_DIR_ONEDRIVE to $WORKING_DIR."
    cp "$WORKING_DIR_ONEDRIVE/.pat" "$WORKING_DIR/.pat"
  fi

  if [ -f "$WORKING_DIR_ONEDRIVE/.npmrc" ] && [ -f "$WORKING_DIR_ONEDRIVE/NuGet.Config" ] && [ -f "$WORKING_DIR_ONEDRIVE/settings.xml" ]; then
    info "Found preconfigured files in $WORKING_DIR_ONEDRIVE, copying to home directory."
    cp "$WORKING_DIR_ONEDRIVE/.npmrc" "$HOME/.npmrc"
    mkdir -p "$HOME/.nuget/NuGet"
    cp "$WORKING_DIR_ONEDRIVE/NuGet.Config" "$HOME/.nuget/NuGet/NuGet.Config"
    mkdir -p "$HOME/.m2"
    cp "$WORKING_DIR_ONEDRIVE/settings.xml" "$HOME/.m2/settings.xml"
    return 0
  fi
  return 1
}

configure_package_feed() {
  local buildscripts_dir
  local email
  local pat
  
  if preconfigured_files; then
    info "Package feed configured from existing files."
    return 0
  fi

  buildscripts_dir="$REPO_DIR"/nhsapp/buildscripts
  fix_nuget_filename

  email="$P1_USER_WIN@hscic.gov.uk"
  pat=$(cat "$WORKING_DIR/.pat")

  "$buildscripts_dir"/configure_package_feed.sh "$pat" "$email"

  fix_nuget_filename
}

configure_package_feed
