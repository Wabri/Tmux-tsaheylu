#!/usr/bin/env bash

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./tsaheylu.tmux

    Plugin the nerves
'
    exit
fi

main() {
    echo do awesome stuff
}

main "$@"
