#!/bin/bash

set -e

PROGNAME=${PROGNAME:-$(basename $(dirname `realpath $0`))}

function build {
    dub build --compiler=ldc2 -b release
}

function version {
    git tag | sort -r --version-sort | head -n1
}

function arch {
    uname -m
}

function os {
    os=$(uname | tr '[:upper:]' '[:lower:]')
    [ $os = 'darwin' ] && echo 'macos' || echo $os
}

function release_name {
    echo "${PROGNAME}-$(version)-$(os)-$(arch)"
}

function archive {
  tar Jcf "$(release_name)".tar.xz $PROGNAME
}

build
archive
