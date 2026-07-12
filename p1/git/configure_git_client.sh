#!/usr/bin/env bash


[ ! git config --global user.name &> /dev/null ] && git config --global user.name "$P1_USER_UNIX"
[ ! git config --global user.email &> /dev/null ] && git config --global user.email "$P1_USER_UNIX@example.com"

[ ! git config --global pull.rebase &> /dev/null ] && git config --global pull.rebase true
[ ! git config --global push.default &> /dev/null ] && git config --global push.default current
[ ! git config --global core.autocrlf &> /dev/null ] && git config --global core.autocrlf false
[ ! git config --global fetch.prune &> /dev/null ] && git config --global fetch.prune true
[ ! git config --global fetch.pruneTags &> /dev/null ] && git config --global fetch.pruneTags true

# git config --global push.autoSetupRemote true
[ ! git config --global core.pager &> /dev/null ] && git config --global core.pager 'less -FRX'
[ ! git config --global core.editor &> /dev/null ] && git config --global core.editor "code --wait"
[ ! git config --global rerere.enabled &> /dev/null ] && git config --global rerere.enabled false
[ ! git config --global color.ui &> /dev/null ] && git config --global color.ui true
[ ! git config --global alias.ch &> /dev/null ] && git config --global alias.ch checkout
[ ! git config --global branch.sort &> /dev/null ] && git config --global branch.sort -committerdate
[ ! git config --global column.ui &> /dev/null ] && git config --global column.ui auto
