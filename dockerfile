FROM ubuntu:latest

WORKDIR /app
COPY gear360pano.sh gear360video.sh test/testgear360pano.sh test/testgear360video.sh .

ENTRYPOINT ["./testgear360pano.sh"]