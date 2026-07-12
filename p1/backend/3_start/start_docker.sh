#!/usr/bin/env bash

function start_docker_macos {
    local ret_code
    colima status > /dev/null 2>&1
    ret_code=$?
    if [ $ret_code -ne 0 ]; then
        echo -e "${YELLOW}Starting colima... ${NC}"
        if ! colima start; then
            echo -e "${YELLOW}Failed to start colima. Trying again after force stop...${NC}"
            colima stop --force

            if ! colima start; then
                echo -e "${YELLOW}Deleting colima networks directory then trying again...${NC}"
                rm -rf "$HOME/.colima/_lima/_networks"
            fi
            
            if ! colima start; then
                echo -e "${RED}Failed to start colima. Exiting...${NC}"
                return 1
            fi
        fi
        sleep 5
    fi
}

function start_docker_ubuntu {
    start_docker_linux
}

function start_docker_linux {
    sudo /etc/init.d/docker start
    sleep 3
}

start_docker_"$MY_OS"
