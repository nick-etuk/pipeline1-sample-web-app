#!/usr/bin/env bash

docker_login_acr() {
    # local exit_status

    # info 'Logging into Azure Container Registry...'
    # az acr login -n nhsapp >/dev/null 2>&1 
    # exit_status=$?
    # if [ $exit_status -eq 0 ]; then
    #     info 'ACR token has not expired. No need to login.'
    #     return
    # fi

    info 'Logging into Azure Container Registry...'
    az acr login -n nhsapp >/dev/null 2>&1 
}

docker_login_acr_token() {
    local docker_user_name
    local docker_token

    docker_user_name='00000000-0000-0000-0000-000000000000'
    docker_token=$(az acr login --name nhsapp \
    --expose-token \
    --output tsv \
    --query accessToken)

    if [ -z "$docker_token" ]; then
        warn 'No ACR token received'
        return 1
    fi

    echo "$docker_token" | docker login nhsapp.azurecr.io \
    --username "$docker_user_name" \
    --password-stdin \
    --tenant 'NHS Digital' \
    --subscription '4bbd6a1f-80a5-485b-a0bb-32c5b6e35c09'
}

docker_login_acr_ubuntu() {
    export BROWSER='/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe --profile-directory="Profile 2"'
    docker_login_acr
}

docker_login_acr_macos() {
    docker_login_acr
}

info 'Logging into Azure...'
# az config set core.login_experience_v2=off #  for azure devops only.
az login --tenant 50f6071f-bbfe-401a-8803-673748e629e2  # for nhs.net account. Not necessary for hscic.gov.uk.

docker_login_acr_"$MY_OS"
