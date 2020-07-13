#!/bin/bash

function manage_dependencies() {
    dpkg -s $1 &>/dev/null
    if [ $? -ne 0 ]; then
        printf " %.s-- installing $1 dependency\n"
        sudo apt-get install $1
    else
        printf " %.s-- $1 already installed\n"
    fi
}

function detect_source() {
    # --enable video feed detector
    sudo rmmod v4l2loopback &>/dev/null

    # --get video feeds (prior activating DSLR video feed)
    ls /dev/video*

    # -- enable driver to detect video feeds from DSLR
    sudo modprobe v4l2loopback exclusive_caps=1 max_buffers=2

    # -- get DSLR source
    ls /dev/video*
    # todo:  '\n %.s-- video source detected! \n'
}

function check_dependencies() {
    #sudo apt update
    manage_dependencies gphoto2
    manage_dependencies v4l2loopback-utils
    manage_dependencies ffmpeg
}

function how_to_stream_msg() {
    printf '\n %.s-- set-up complete!\n'
    printf ' %.s-- to start streaming enter the command:\n'
    printf ' %.s   gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 <DSLR-source> \n'
    printf '\n %.s-- n.b.:\n'
    printf ' %.s-- your <DSLR-source> is the newest appearing </dev/video*> \n'
}

function main() {
    check_dependencies
    printf '\n %.s-- Please make sure you soft-eject the DSLR! \n'
    while true; do
        read -p " -- DSLR ejected? [Y/N]" yn
        printf '%.s---------------------------------------------------------- \n'
        case $yn in
        [Yy]*)
            # -- detect DSLR source
            detect_source
            if [ "$?" -eq "0" ]; then

                gphoto2 --auto-detect
            else
                printf ' %.s-- something went wrong.\n'
            fi
            break
            ;;
        [Nn]*) exit ;;
        *) printf ' %.s-- something went wrong.\n' ;;
        esac
    done

    while true; do
        read -p " -- Is you DSLR Model detected and correctly indicated? [Y/N]" yn
        case $yn in
        [Yy]*)
            how_to_stream_msg
            break
            ;;
        [Nn]*)
            printf ' %.s-- something went wrong.\n'
            exit
            ;;
        *) printf ' %.s-- something went wrong.\n' ;;
        esac
    done
}

main
