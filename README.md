# About

Docker image to create equirectangular panoramic photos or videos from Samsung Gear 360. It supports
generation 1 (SM-C200) and 2 (2017 or SM-R210).

This is based on the excellent work of [ultramango](https://github.com/ultramango/gear360pano). The core functionality is largely unchanged. The primary difference is wrapping the original scripts in Docker to streamline installation and dependency management. 

![Samsung Gear 360](gear360.jpg)

# Notes

* The Docker image only supports Linux containers, not Windows containers. However, it can be used in WSL on Windows. 
* Instead of specifying individual files to process, input and output volumes must be provided. All video or photo files in the input volume are processed.
* Docker does not have access to the GPU by default. The container will work without any GPU support, but it will be slower. See the [GPU](#gpu) section below for more information.
* The Pannellum viewer is not included.
* The original command line options are still supported except 
    * `-p` for parallel processing is always specified
    * `-o` for setting the output directory is unsupported as the output volume must be specified
    * `-g` for updating the Pannellum code is unsupported as Pannellum is not included
    * `-t` for setting the temp directory is unsupported. Instead, a Docker volume can be mapped to container's /tmp directory. 
* Multiblend is included in the Docker image. 

# Installation

1. Enlist this repository (or download/unzip it) onto a machine that has Docker installed. 
2. From a console, go to the root directory. 
3. Build the docker container: 
    ```
    docker build -t gear360 .
    ```

# Usage

The container must be invoked with volumes for the input and output directories mapped to `/in` and `/out` respectively, plus a command line argument of either `pano` or `video` to determine which type of processing to perform. Other command line switches for the two modes are listed below. 

## Photos

If the current directory has both an `input` folder with `360_0001.JPG` in it and an empty `output` folder, running

```
docker run --rm -v "input:/in" -v "output:/app/html/data" gear360 pano
```

will produce `360_0001_pano.jpg` in the output directory. One JPG file will be produced in the output directory for each one in the input directory. 

### Switches

* `-a` - enforce processing of all files (default: skip already processed)
* `-m` - use multiblend instead of Hugin's enblend (faster but lower quality)
* `-n` - do not use GPU (slower but safer)
* `-q [quality]` - set JPEG quality (default: 97)
* `-r` - remove source file after processing (use with care)
* `-h` - display help

### Notes

* script currently supports only the highest resolution from the camera (7776x3888)
* ensure that you have something like 150 MB of free disk space for intermediate files. If you're tight
on disk space, switch to png format (change inside the script), but the processing time increases about four times
* on Intel i7, 16 GB memory, NVIDIA 1080 it takes ~10 seconds to produce the panorama (using enblend)

## Videos

If the current directory has both an `input` folder with `video.mp4` in it and an empty `output` folder, running

```
docker run --rm -v "input:/in" -v "output:/app/html/data" gear360 video
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

The [Usage section](#usage) describes the easiest way to use the container: enlist, build, run. However, because Docker by default does not have access to the GPU, this will cause all processing to fall back to the CPU. If you need to convert images and videos infrequently and/or you have a lot of time to let it run in the background, this may be sufficient, especially with modern processors. However, if you need the additional speed that the GPU can provide, it's possible to grant Docker access to the GPU. 

Configuring Docker to have access to the GPU is beyond the scope of this README, but there are [several](https://www.howtogeek.com/devops/how-to-use-an-nvidia-gpu-with-docker-containers/) guides online, including configuring [WSL 2](https://learn.microsoft.com/en-us/windows/ai/directml/gpu-cuda-in-wsl) to allow Linux (and thus Docker) to use the GPU. This typically requires the installation of a new driver and some extra configuration on the host machine. 

Once Docker has been configured, the commands above will use the GPU if you additionally pass in the `--gpus all` flag. For example, the command above for converting a video would become
```
docker run --rm --gpus all -v "input:/in" -v "output:/app/html/data" gear360 video
```