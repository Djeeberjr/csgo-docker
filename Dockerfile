FROM cm2network/steamcmd:latest

COPY entrypoint.sh /home/steam/entrypoint.sh

RUN mkdir -p /home/steam/server

USER steam
VOLUME /home/steam/server
WORKDIR /home/steam/

ENV METAMOD_DL_URL "https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1145-linux.tar.gz"
ENV SOURCEMOD_DL_URL "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6524-linux.tar.gz"

ENTRYPOINT /home/steam/entrypoint.sh
