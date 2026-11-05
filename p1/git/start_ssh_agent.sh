#!/usr/bin/env bash

start_ssh_agent() {
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/id_ed25519
    chmod 644 ~/.ssh/id_ed25519.pub

    # todo: Add this to ~/.zshrc

    if ps -p "$SSH_AGENT_PID" > /dev/null
    then
        info "ssh agent is running. PID: $SSH_AGENT_PID"
        return
    fi

    info "Starting ssh-agent"
    eval "$(ssh-agent -s)"
    if ps -p "$SSH_AGENT_PID" > /dev/null
    then
        info "ssh agent is running. Adding ssh key..."
        ssh-add ~/.ssh/id_ed25519
    else
        error 'Failed to start ssh agent'
    fi
}
