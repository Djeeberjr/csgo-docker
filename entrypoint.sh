#!/bin/bash

set -eo pipefail

/home/steam/steamcmd/steamcmd.sh +force_install_dir /home/steam/server +login anonymous +app_update 740 +quit


if [ ! -e "$HOME/server/csgo/addons/metamod.vdf" ]; then
    echo "Installing Metamod"
    curl "$METAMOD_DL_URL" -o /tmp/metamod.tar.gz
    tar -xf /tmp/metamod.tar.gz -C "$HOME/server/csgo"
    rm /tmp/metamod.tar.gz

    echo "Install Sourcemod"
    curl "$SOURCEMOD_DL_URL" -o /tmp/sourcemod.tar.gz
    tar -xf /tmp/sourcemod.tar.gz -C "$HOME/server/csgo"
    rm /tmp/sourcemod.tar.gz
fi

if [ -n "$MAP_ROTATION" ]; then
    echo -n "$MAP_ROTATION" | sed 's/,/\n/g' | tee "$HOME/server/csgo/mapcycle.txt" "$HOME/server/csgo/maplist.txt"
else
    echo -n "" | tee "$HOME/server/csgo/mapcycle.txt" "$HOME/server/csgo/maplist.txt"
fi

SRCDS_ARGS="-usercon"

if [ -n "$GSLT" ]; then
    SRCDS_ARGS="${SRCDS_ARGS} +sv_setsteamaccount ${GSLT}"
else
    echo "GSLT not set. Connections will be restricted to LAN only."
fi

if [ -n "$WORKSHOP_AUTHKEY" ]; then
    SRCDS_ARGS="${SRCDS_ARGS} -authkey ${WORKSHOP_AUTHKEY}"
else
    echo "WORKSHOP_AUTHKEY not set. Workshop maps will be unsupported."
fi

if [ -n "$INSECURE" ]; then
    SRCDS_ARGS="${SRCDS_ARGS} -insecure"
    echo "Running with VAC disabled."
fi

if [ -n "$NOMASTER" ]; then
    SRCDS_ARGS="${SRCDS_ARGS} -nomaster"
    echo "Running with nomaster."
fi

if [ -n "$MAX_PLAYERS" ]; then
    SRCDS_ARGS="${SRCDS_ARGS} -maxplayers $MAX_PLAYERS"
    echo "Maxplayers set to ${MAX_PLAYERS}."
fi

if [ -n "$TICKRATE" ]; then
    SRCDS_ARGS="${SRCDS_ARGS} -tickrate $TICKRATE"
    echo "Tickrate set to $TICKRATE."
fi

if [ -n "$NOHLTV" ]; then
    SRCDS_ARGS="${SRCDS_ARGS} -nohltv"
    echo "Disableing HLTV."
fi

if [ -n "$RCONPW" ]; then
    SRCDS_ARGS="${SRCDS_ARGS} +rcon_password $RCONPW"
    echo "Setting RCON password to: $RCONPW"
fi

if [ -n "$GAMEMODE" ]; then 
    case "$GAMEMODE" in
        "casual" | "competitive" | "wingman" | "weaponexpert")
            SRCDS_ARGS="${SRCDS_ARGS} +game_type 0"
            ;;
        "armsrace" | "demolition" | "deathmatch")
            SRCDS_ARGS="${SRCDS_ARGS} +game_type 1"
            ;;
        "custom" )
            SRCDS_ARGS="${SRCDS_ARGS} +game_type 3"
            ;;
        "guardian" | "coop" )
            SRCDS_ARGS="${SRCDS_ARGS} +game_type 4"
            ;;
        "dangerzone" )
            SRCDS_ARGS="${SRCDS_ARGS} +game_type 6"
            ;;
    esac

    case "$GAMEMODE" in 
        "casual" | "armsrace" | "custom" | "guardian" | "dangerzone")
            SRCDS_ARGS="${SRCDS_ARGS} +game_mode 0"
            ;;
        "competitive" | "demolition" | "coop")
            SRCDS_ARGS="${SRCDS_ARGS} +game_mode 1"
            ;;
        "wingman" | "deathmatch")
            SRCDS_ARGS="${SRCDS_ARGS} +game_mode 2"
            ;;
        "weaponexpert")
            SRCDS_ARGS="${SRCDS_ARGS} +game_mode 3"
            ;;
    esac

    case "$GAMEMODE" in 
        "stab_zap")
            SRCDS_ARGS="${SRCDS_ARGS} +game_type 0 +game_mode 0 +sv_skirmish_id 1"
            ;;
        "ffa")
            SRCDS_ARGS="${SRCDS_ARGS} +game_type 0 +game_mode 2 +sv_game_mode_flags 32"
            ;;
        "flying_scoutsman")
            SRCDS_ARGS="${SRCDS_ARGS} +game_type 0 +game_mode 0 +sv_skirmish_id 3"
            ;;
        "trigger_discipline")
            SRCDS_ARGS="${SRCDS_ARGS} +game_type 0 +game_mode 0 +sv_skirmish_id 4"
            ;;
        "headshots")
            SRCDS_ARGS="${SRCDS_ARGS} +game_type 0 +game_mode 2 +sv_skirmish_id 6"
            ;;
        "hunter_gatherers")
            SRCDS_ARGS="${SRCDS_ARGS} +game_type 0 +game_mode 2 +sv_skirmish_id 7"
            ;;
        "retakes")
            SRCDS_ARGS="${SRCDS_ARGS} +game_type 0 +game_mode 0 +sv_skirmish_id 12"
            ;;
        "competitive_short")
            SRCDS_ARGS="${SRCDS_ARGS} +game_type 0 +game_mode 1 +sv_game_mode_flags 32"
            ;;
    esac 

fi

if [ -n "$MAP" ]; then
    SRCDS_ARGS="${SRCDS_ARGS} +map ${MAP}"
fi

if [ -n "$MAPGROUP" ]; then
    SRCDS_ARGS="${SRCDS_ARGS} +mapgroup ${MAPGROUP}"
fi

if [ -n "$WORKSHOP_MAP" ]; then
    SRCDS_ARGS="${SRCDS_ARGS} +host_workshop_map ${WORKSHOP_MAP}"

    if [ -z "$WORKSHOP_AUTHKEY" ]; then
        echo "WORKSHOP_MAP set but no WORKSHOP_AUTHKEY. This may not work."
    fi
fi

if [ -n "$WORKSHOP_COLLECTION" ]; then
    SRCDS_ARGS="${SRCDS_ARGS} +host_workshop_collection ${WORKSHOP_COLLECTION}"

    if [ -z "$WORKSHOP_AUTHKEY" ]; then
        echo "WORKSHOP_COLLECTION set but no WORKSHOP_AUTHKEY. This may not work."
    fi
fi

CVARS=$(env | awk -F "=" '/^CVAR_/ { sub("CVAR_","",$1); print "+"tolower($1),($2 ~ /^[0-9]+$/)?$2:"\""$2"\""," "}' | tr -d "\n")

echo "Running command: srcds_run -game csgo $SRCDS_ARGS $CVARS"

/home/steam/server/srcds_run -game csgo $SRCDS_ARGS $CVARS
