FROM cm2network/steamcmd:latest

COPY entrypoint.sh /home/steam/entrypoint.sh

RUN mkdir -p /home/steam/server

USER steam
VOLUME /home/steam/server
WORKDIR /home/steam/

ENTRYPOINT /home/steam/entrypoint.sh
