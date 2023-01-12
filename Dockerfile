FROM cm2network/steamcmd:latest

COPY entrypoint.sh /home/steam/entrypoint.sh

RUN mkdir -p /home/steam/server

USER steam
VOLUME /home/steam/server
WORKDIR /home/steam/

ENV METAMOD_DL_URL "https://mms.alliedmods.net/mmsdrop/1.12/mmsource-1.12.0-git1165-linux.tar.gz"
ENV SOURCEMOD_DL_URL "https://sm.alliedmods.net/smdrop/1.12/sourcemod-1.12.0-git6968-linux.tar.gz"

ENTRYPOINT /home/steam/entrypoint.sh
