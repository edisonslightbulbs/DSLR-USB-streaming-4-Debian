#!/bin/bash

# -- helper for detecting DSLR video source feed
function detect-source() {
    # --enable video feed detector
    sudo rmmod v4l2loopback &>/dev/null

    # --get video feeds (prior activating DSLR video feed)
    ls /dev/video*

    # -- enable driver to detect video feeds from DSLR
    sudo modprobe v4l2loopback exclusive_caps=1 max_buffers=2

    # -- get DSLR source
    ls /dev/video*
    # todo:  '\n %.s-- video source detected! \n'

    printf ' %.s-- DSLR detected!\n'
    printf ' %.s-- DSLR not detected!\n'
}

printf ' %.s-- Please make sure you soft-eject the DSLR! \n'
while true; do
    read -p " -- DSLR ejected?" yn
    case $yn in
    [Yy]*)
        # -- detect DSLR source
        detect-source
        if [ "$?" -eq "0" ]; then
            #-- feedback on detected DSLR
            gphoto2 --auto-detect

            # -- pipe DSLR video feed (App ready: OBS, Skype, Teams ...)
            gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video2
            printf ' %.s-- DSLR now streaming.\n'
        else
            printf ' %.s-- something went wrong.\n'
        fi
        break
        ;;
    [Nn]*) exit ;;
    *) printf ' %.s-- something went wrong.\n' ;;
    esac
done
