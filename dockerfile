# Build multiblend
FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    g++ \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev

WORKDIR /src
COPY multiblend/src .

RUN g++ -msse4.1 -pthread -ffast-math -Ofast -o multiblend multiblend.cpp -lm -lpng -ltiff -ljpeg

# Build final image
FROM ubuntu:latest

COPY --from=0 /src/multiblend /usr/local/bin/multiblend

RUN apt-get update && apt-get install -y \
    hugin \
    imagemagick \
    parallel \
    ffmpeg

WORKDIR /app
COPY gear360pano.sh gear360video.sh *.pto test/testgear360pano.sh test/testgear360video.sh .

ENTRYPOINT ["./testgear360video.sh"]