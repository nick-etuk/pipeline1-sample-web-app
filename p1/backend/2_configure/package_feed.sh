#!/usr/bin/env bash
fix_nuget_filename() {
  local nuget_dir
  local bad_filename
  local good_filename

  # buildscripts_dir="$REPO_DIR"/nhsapp/buildscripts
  nuget_dir="$HOME/.nuget/NuGet"

  bad_filename="$nuget_dir/Nuget.config"
  good_filename="$nuget_dir/NuGet.Config"

  if [ -f "$bad_filename" ]; then
    mv "$bad_filename" "$good_filename"
    warn "Fixed capitalisation of NuGet.Config in $nuget_dir"
  fi
}

has_preconfigured_files() {
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

save_preconfigured_files() {
  if [ -z "$WORKING_DIR_ONEDRIVE" ]; then
    warn "WORKING_DIR_ONEDRIVE is not set. Cannot save preconfigured files."
    return
  fi

  info "Saving preconfigured files to $WORKING_DIR_ONEDRIVE"
  cp "$HOME/.npmrc" "$WORKING_DIR_ONEDRIVE/.npmrc"
  cp "$HOME/.nuget/NuGet/NuGet.Config" "$WORKING_DIR_ONEDRIVE/NuGet.Config"
  cp "$HOME/.m2/settings.xml" "$WORKING_DIR_ONEDRIVE/settings.xml"
}

configure_package_feed() {
  local buildscripts_dir
  local email
  local pat
  
  if has_preconfigured_files; then
    info "Package feed configured from existing files."
    return
  fi

  buildscripts_dir="$REPO_DIR"/nhsapp/buildscripts
  # fix_nuget_filename

  if [ "$MY_OS" = 'macos' ]; then
    email="$P1_USER_UNIX@hscic.gov.uk"
  else
    email="$P1_USER_WIN@hscic.gov.uk"
  fi
  pat=$(cat "$WORKING_DIR/.pat")

  info 'Configuring package feed'
  info "email: $email"
  info "PAT: $pat"
  "$buildscripts_dir"/configure_package_feed.sh "$pat" "$email"

  fix_nuget_filename
  save_preconfigured_files
}

configure_package_feed
