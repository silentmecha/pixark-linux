#!/bin/bash
trap "clean_up" SIGTERM
function clean_up() {
    ${HOME}/mcrcon/mcrcon -P ${RCONPORT} -p ${SERVERADMINPASSWORD} -w 1 \
    'broadcast Warning!!\nServer stopping in 5' \
    'broadcast Warning!!\nServer stopping in 4' \
    'broadcast Warning!!\nServer stopping in 3' \
    'broadcast Warning!!\nServer stopping in 2' \
    'broadcast Warning!!\nServer stopping in 1' \
    'saveworld' \
    'doExit'
    kill -SIGINT $serverPID
}
if [ ! -d "${HOME}/.wine" ]; then
    echo "Configuring wine for the first time"
    wine wineboot --init
fi

##Define all variables needed in this script
arguments="-NoBattlEye -NoHangDetection"
command="?listen"

##Chech if AltSaveDirectoryName is set
if [ -n "${ALTSAVEDIRECTORYNAME}" ]; then
    command="${command}?AltSaveDirectoryName=${ALTSAVEDIRECTORYNAME}"
    save_dir="${STEAM_SAVEDIR}/${ALTSAVEDIRECTORYNAME}"
    arguments="${arguments} -ConfigsUseAltDir"
else
    save_dir=${STEAM_SAVEDIR}
fi
# We assume that if the config is missing, that this is a fresh container
if [ ! -f "${save_dir}/Config/WindowsServer/GameUserSettings.ini" ]; then
    #Set Session Name
    mkdir -p "${save_dir}/Config/WindowsServer"
    chmod -R 776 "${save_dir}"
    touch ${save_dir}/Config/WindowsServer/GameUserSettings.ini \
        && echo -e "[SessionSettings]\r\nSessionName=${SESSIONNAME}" > ${save_dir}/Config/WindowsServer/GameUserSettings.ini
fi

#Handle ?Options
#Check valid map name
if [[ "${MAP}" != "CubeWorld_Light" && "${MAP}" != "SkyPiea_light" ]]; then
    echo "Using default map"
    command="CubeWorld_Light${command}"
else
    command="${MAP}${command}"
fi
#Chech if server password is set
if [ -n "${SERVERPASSWORD}" ]; then
    command="${command}?ServerPassword=${SERVERPASSWORD}"
fi
#Check if RCON password is set else disable RCON for security
if [ -n "${SERVERADMINPASSWORD}" ]; then
    command="${command}?ServerAdminPassword=${SERVERADMINPASSWORD}?RCONEnabled=${RCONENABLED}?RCONPort=${RCONPORT}"
else
    command="${command}?RCONEnabled=False"
fi
#Build full ?Options
command="${command}?MaxPlayers=${MAXPLAYERS}?CULTUREFORCOOKING=${CULTUREFORCOOKING}"

##Handle all other flags
#Check if the map seed is defined
if [ -n "${MAPSEED}" ]; then
    arguments="${arguments} -Seed=${MAPSEED}"
fi
#Check if the cluster id is definded
if [ -n "${CLUSTERID}" ]; then
    arguments="${arguments} -clusterid=${CLUSTERID}"
fi

arguments="${arguments} -Port=${PORT} -QueryPort=${QUERYPORT} -RCONPort=${RCONPORT} -CubePort=${CUBEPORT} -cubeworld=${CUBEWORLD} -server -log"
cd ${STEAMAPPDIR}
wine64 ${STEAMAPPDIR}/ShooterGame/Binaries/Win64/PixARKServer.exe $command $arguments & serverPID=$!
#wine64 ${STEAMAPPDIR}/ShooterGame/Binaries/Win64/PixARKServer.exe "${MAP}?listen?ServerPassword=${SERVERPASSWORD}?ServerAdminPassword=${SERVERADMINPASSWORD}?MaxPlayers=${MAXPLAYERS}?RCONEnabled=${RCONENABLED}?CULTUREFORCOOKING=${CULTUREFORCOOKING}" -NoBattlEye -NoHangDetection -Port=${PORT} -QueryPort=${QUERYPORT} -RCONPort=${RCONPORT} -CubePort=${CUBEPORT} -cubeworld=${CUBEWORLD} -server -log
wait $serverPID
exit 0
