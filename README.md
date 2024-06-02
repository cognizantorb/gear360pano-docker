# About

Docker image to create equirectangular panoramic photos or videos from Samsung Gear 360. It supports
generation 1 (SM-C200) and 2 (2017 or SM-R210).

This is based on the excellent work of [ultramango](https://github.com/ultramango/gear360pano). The core functionality is largely unchanged. The primary difference is wrapping the original scripts in Docker to streamline installation and dependency management. 

![Samsung Gear 360](gear360.jpg)

# Notes

* The Docker image only supports Linux containers, not Windows containers. However, it can be used in WSL on Windows. 
* Instead of specifying individual files to process, input and output volumes must be provided. All video or photo files in the input volume are processed.
* The Docker container is constrained to only use the CPU. See [GPU](#gpu) for more details.
* The Pannellum viewer is not included.
* The original command line options are still supported except 
    * `-p` for parallel processing is always specified
    * `-n` for disabling the GPU is always specified, as the GPU current cannot be used with this Docker image
    * `-o` for setting the output directory is unsupported as the output volume must be specified
    * `-g` for updating the Pannellum code is unsupported as Pannellum is not included
    * `-t` for setting the temp directory is unsupported; instead, a Docker volume can be mapped to container's /tmp directory
* Multiblend is included in the Docker image. 

# Installation

1. Enlist this repository (or download/unzip it) onto a machine that has Docker installed. 
2. From a console, go to the root directory of the enlistment. 
3. Build the docker container by entering the docker build command manually or using the helper script: 
    ```
    ./build.sh
    ```

# Usage

The container must be invoked with volumes for the input and output directories mapped to `/in` and `/out` respectively, plus a command line argument of either `pano` or `video` to determine which type of processing to perform. Other command line switches for the two modes are listed below. The small helper script `run.sh` can help with the syntax, but it's just a single command to invoke manually. 

## Photos

If there's an `~/input360` folder with `360_0001.JPG` in it and an empty `~/output360` folder, running

```
./run.sh ~/input360 ~/output360 pano
```

will produce `360_0001_pano.jpg` in the output directory. One JPG file will be produced in the output directory for each one in the input directory. 

### Switches

* `-a` - enforce processing of all files (default: skip already processed)
* `-m` - use multiblend instead of Hugin's enblend (faster but lower quality)
* `-q [quality]` - set JPEG quality (default: 97)
* `-r` - remove source file after processing (use with care)
* `-h` - display help

### Notes

* script currently supports only the highest resolution from the camera (7776x3888)
* ensure that you have something like 150 MB of free disk space for intermediate files. If you're tight
on disk space, switch to png format (change inside the script), but the processing time increases about four times
* on Intel i7, 16 GB memory, NVIDIA 1080 it takes ~10 seconds to produce the panorama (using enblend)

## Videos

If there's an `~/input360` folder with `video.mp4` in it and an empty `~/output360` folder, running

```
./run.sh ~/input360 ~/output360 video
```

will produce ```video_pano.mp4``` in the output directory. One MP4 file will be produced in the output directory for each one in the input directory. 

### Switches

* `-s` - optimise stitching for speed (quality will suffer)
* `-h` - display help

### Notes

* video stitching works by converting it to image files, stitching them and then re-coding, it might
require a lot of disk space (gigabytes or even more) as the long videos will result in many image
files

# GPU

Docker does not have access to the GPU by default. While CUDA/OpenCL support can be enabled for the container, neither enblend or multiblend currently support this and won't use the GPU even when in a Docker container that's configured to allow it. This will cause all processing to fall back to the CPU. If you need to convert images and videos infrequently and/or you have time to let it run in the background, this may be sufficient, especially with modern processors. However, if you need the additional speed that the GPU can provide, you'll need to install the prerequisites on your host machine and run the script outside of Docker. 