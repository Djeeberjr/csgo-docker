FROM cm2network/steamcmd:latest

COPY entrypoint.sh /home/steam/entrypoint.sh

USER steam
VOLUME /home/steam/server
WORKDIR /home/steam/

ENTRYPOINT /home/steam/entrypoint.sh
