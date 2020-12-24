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

# We assume that if the config is missing, that this is a fresh container
if [ ! -f "${STEAMAPPDIR}/ShooterGame/Saved/Config/WindowsServer/GameUserSettings.ini" ]; then
    #Set Session Name
    mkdir -p "${STEAMAPPDIR}/ShooterGame/Saved/Config/WindowsServer"
    chmod -R 777 "${STEAMAPPDIR}/ShooterGame/Saved"
    touch ${STEAMAPPDIR}/ShooterGame/Saved/Config/WindowsServer/GameUserSettings.ini && echo -e "[SessionSettings]\r\nSessionName=${SESSIONNAME}" > ${STEAMAPPDIR}/ShooterGame/Saved/Config/WindowsServer/GameUserSettings.ini
fi

#Handle ?Options
command=""
##Check valid map name
if [[ "${MAP}" != "CubeWorld_Light" && "${MAP}" != "SkyPiea_light" ]]; then
    echo "Using default map"
    command="CubeWorld_Light?listen"
else
    command="${MAP}?listen"
fi
##Chech if server password is set
if [ -n "${SERVERPASSWORD}" ]; then
    command="${command}?ServerPassword=${SERVERPASSWORD}"
fi
##Check if RCON password is set else disable RCON for security
if [ -n "${SERVERADMINPASSWORD}" ]; then
    command="${command}?ServerAdminPassword=${SERVERADMINPASSWORD}?RCONEnabled=${RCONENABLED}?RCONPort=${RCONPORT}"
else
    command="${command}?RCONEnabled=False"
fi
##Build full ?Options
command="${command}?MaxPlayers=${MAXPLAYERS}?CULTUREFORCOOKING=${CULTUREFORCOOKING}"

#Handle -Options
arguments=" -NoBattlEye -NoHangDetection"
if [ -n "${MAPSEED}" ]; then
    arguments="${arguments} -Seed=${MAPSEED}"
fi

arguments="${arguments} -Port=${PORT} -QueryPort=${QUERYPORT} -RCONPort=${RCONPORT} -CubePort=${CUBEPORT} -cubeworld=${CUBEWORLD} -server -log"
cd ${STEAMAPPDIR}
wine64 ${STEAMAPPDIR}/ShooterGame/Binaries/Win64/PixARKServer.exe $command $arguments & serverPID=$!
#wine64 ${STEAMAPPDIR}/ShooterGame/Binaries/Win64/PixARKServer.exe "${MAP}?listen?ServerPassword=${SERVERPASSWORD}?ServerAdminPassword=${SERVERADMINPASSWORD}?MaxPlayers=${MAXPLAYERS}?RCONEnabled=${RCONENABLED}?CULTUREFORCOOKING=${CULTUREFORCOOKING}" -NoBattlEye -NoHangDetection -Port=${PORT} -QueryPort=${QUERYPORT} -RCONPort=${RCONPORT} -CubePort=${CUBEPORT} -cubeworld=${CUBEWORLD} -server -log
wait $serverPID
exit 0
