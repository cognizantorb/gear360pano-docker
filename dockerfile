FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    hugin \
    imagemagick \
    parallel \
    ffmpeg

WORKDIR /app
COPY gear360pano.sh gear360video.sh *.pto test/testgear360pano.sh test/testgear360video.sh .

ENTRYPOINT ["./testgear360pano.sh"]