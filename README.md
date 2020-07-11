# Streaming from USB-enabled DSLR cameras on Debian distros  📸

Helper scripts for installing and running **USB-enabled DSLR** cameras on Debian
distros.

#### Manual steps after (if you choose not to use the helper scripts)

1. install dependencies
```
sudo apt install -y gphoto2
sudo apt install -y v4l2loopback-utils
sudo apt install -y ffmpeg
```

2. plug the cameras' USB cable and unmount/eject the camera
(its initially mounted as a drive)

3. enable and determine the virtual video device (ignore errors)
```
sudo rmmod v4l2loopback
```

4. list all current video feeds (this will make it simpler to know which feed corresponds to the DSLR after we add it)
```
ls /dev/video*
```

5. activate `v3l2loopbacka`  (driver responsible for  enabling DSLR feed)
```
sudo modprobe v4l2loopback exclusive_caps=1 max_buffers=2
```


6. list all video feed devices once more identify new DSLR feed
```
ls /dev/video*

```

7. detect DSLR feeds' camera make
```
gphoto2 --auto-detect
```

8. get video feed and pipe it out for use as a virtual device
```
gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 <DSLR-feed>
```
for example:
```
gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video2
```

#### Using the created virtual device

Simply, open app (e.g. OBS studio), and look for the virtually enabled device.

* * *

#### Screen cast

`Comming soon!`

be sure to checkout original [ youtube ](https://www.youtube.com/watch?v=EqrZrKC1WA0&list=LLKgbhlPIeztpJiArOXmEvCA&index=3&t=4s) howto post

Handy? Star and [ follow ](https://github.com/edisonslightbulbs/VIM-cheatsheet/subscription)  the repo to keep up with all the updates.
If there is a better way around something, or, if I'm just plain wrong about something, please create an issue and [ contribute ](https://github.com/edisonslightbulbs/VIM-cheatsheet/fork) to the repo
   👏🍻🍻

#### Promotion

Worth a second look? Let's propagate to fill all the nooks and crannies that people want it to fill!
If you are interested in chatting about day-to-day tools like git and vim,
let's get into it on [ twitter ](https://twitter.com/antiqueeverett) and [ youtube](https://www.youtube.com/channel/UCKkeK-xQiIWc3jzBbUel9ww?view_as=subscriber).

###### Utility provided in this repository is purely academic and subject to change.
