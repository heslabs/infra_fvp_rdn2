#!/bin/bash

ROOT_DIR=$(pwd)
#TAG="refs/tags/RD-INFRA-2024.04.17"
TAG="refs/tags/RD-INFRA-2024.07.15"
MANIFEST="pinned-rdn2.xml"
GIT_USER="Ann Cheng"
GIT_MAIL="ann.cheng@arm.com"
WORKSPACE="rd-infra"
WORKSPACE_PATH=$ROOT_DIR/$WORKSPACE
export PATH="$HOME/.bin:$PATH"
export MODEL=/home/infra/infra_fvp/FVP_RD_N2/models/Linux64_GCC-9.3/FVP_RD_N2


git config --global user.name "$GIT_USER"
git config --global user.email "$GIT_MAIL"

# Function to check if a command exists, and exit if not found
check_command() {
    if ! command -v $1 &> /dev/null
    then
        echo "Error: $1 is not installed."
        exit 1
    fi
}

install_repo_cmd() {
    if [ ! -x "$HOME/.bin/repo" ]; then
        mkdir -p ~/.bin
        export REPO=$(mktemp /tmp/repo.XXXXXXXXX)
        curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
        chmod a+rx ~/.bin/repo
    fi
}

get_rd_infra_src() {
    if [ -d "$WORKSPACE" ]; then
        echo "The directory '$WORKSPACE' already exists. Skip donwloading Software Stack"
    else
        echo "Donwload RD-INFRA Software Stack"
        mkdir -p $WORKSPACE
        cd $WORKSPACE
        repo init -u https://git.gitlab.arm.com/infra-solutions/reference-design/infra-refdesign-manifests.git \
            -m "$MANIFEST" \
            -b "$TAG" \
            --depth=1
        repo sync -c -j $(nproc) --fetch-submodules --force-sync --no-clone-bundle
        cd $ROOT_DIR
    fi
}

create_builder_docker_image() {
    cd $WORKSPACE/container-scripts
    docker image inspect rdinfra-builder > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        ./container.sh build
    fi
    cd $ROOT_DIR
}

build-test-uefi() {
    docker run -v $WORKSPACE_PATH:$WORKSPACE_PATH \
    --network host \
    --env="DISPLAY" \
    -ti --rm rdinfra-builder \
    bash -c "cd $WORKSPACE_PATH && ./build-scripts/build-test-uefi.sh -p rdn2 all"
}


check_command git
check_command curl
check_command python3
check_command docker

install_repo_cmd
get_rd_infra_src

create_builder_docker_image
build-test-uefi



git config --global --unset user.name
git config --global --unset user.email

cd $ROOT_DIR