# Standard enviroment variable

`GSLT`: Game Server Login Token. Required if you want your server to public. Get your token [here](https://steamcommunity.com/dev/managegameservers).

`WORKSHOP_AUTHKEY`: Required if you want to play workshop maps. Get your token [here](https://steamcommunity.com/dev/apikey)

`MAP`: Default map to start.

`INSECURE`: Set this var to disable VAC.

`MAX_PLAYERS`: Overide max players.

`TICKRATE`: Tickrate of the server. Default is 64.

`NOHLTV`: Disable HLTV.

`MAPGROUP`: Mapgroup to cycle through. Values: `mg_bomb`, `mg_hostage`, `mg_dust`, `mg_demolition` or `mg_armsrace`.

`RCONPW`: Sets the RCON password.

`WORKSHOP_MAP`: Specify with what workshop map to start.

`WORKSHOP_COLLECTION`: Specify what workshop collection to cycle through.

`GAMEMODE`: What gamemode to load. Not the same as the `game_mode` cvar. Value gets translated to a gamemode/gametype combination. Available values are: `casual`,`competitive`, `wingman`, `armsrace`, `deathmatch`, `custom`, `coop`, `dangerzone`, `weaponexpert`,`demolition`,`stab_zap`,`ffa`,`flying_scoutsman`,`trigger_discipline`,`headshots`,`hunter_gatherers`,`retakes`,`competitive_short`. For more information see [here](https://developer.valvesoftware.com/wiki/CS:GO_Game_Mode_Commands). 

`MAP_ROTATION` comma separated list of maps to populate the `mapcycle.txt` and `maplist.txt` files.

`SM_ADMIN` comma separated list of ids to grand admin privileges e.g. "STEAM_0:1:57874277", "!127.0.0.1"

# Custom conVars

You can set ANY other variable by just prefixing the conVar with `CVAR_`. So for example if you want to set `mp_disable_autokick 1` just set the enviroment variable `CVAR_MP_DISABLE_AUTOKICK` to `1`. Upper or lower case is ignored.

# Minimum configuration

The minimum variables you should set for a somewhat working game is is `GSLT`, `MAP` and maybe `GAMEMODE`. You can also check out the example [docker-compose.yml](docker-compose.yml).

# Misc 

Because docker-compose recreated the container every time you update a varaible you can mount `/home/steam/server` to a volume so that you dont have to redownload the server every time you change something. 

The game gets updated every time the image restarts.
