# Ani-Quality

##### This is the CPU version. Check out the other branches for the GPU version.

Ani-Quality is a script made to enhance the quality of any animated video. It uses Waifu2x, a tool which enhances the quality of Anime-style art using Deep Convolutional Neural Networks.

**NOTE: This tool only works for windows**

## Donation
**BTC:** 1N35DzXEqqBY7UTMWDv1NU5sAAFm7DNbNm
Send me some Bitcoins!!
As soon as I receive 0.001, I will Rewrite a more efficient version of the script in Python, which will not be OS restricted.

## Installation
Copy **ffmpeg.exe**, **ffprobe.exe**, **7za.exe** and **waifu2x-caffe.zip** in the same folder as **install.bat**
Then execute **install.bat**

This script copies the essential files to the system32 folder, adding the dependencies to the path.

## Usage
Copy the video file you desire to enhance in the same folder as **AniQuality.bat**
Enter the type of file. (MKV, MP4, AVI etc.)
Select one of the eight resolutions, that the script currently supports.
```
1.        144p        176x144
2.        240p        320x240
3.        360p        480x360
4.        480p        640x480
5.        720p        1280x720
6.        1080p       1920x1080
7.        4K          3840x2160
8.        8K          7680x4320
```
Let the script do its magic.

## How AniQuality works
AniQuality uses FFmpeg to extract frames out of the video. Then Each one of the frames is upscaled using waifu2x, then all the upscaled images are stitched together to make the upsampled video.

## Problems with AniQuality
There are a number of issues with the script, the most important being that it requires tons of computational power and storage. A 20 minute 30 FPS video has around 35000 Frames. Each Frame is 3 MB. The Total is 105000 MB or 105 GB. Also if you don't have a GPU, it will take forever to process.
