FROM silentmecha/pixark-linux:latest

LABEL maintainer="silent@silentmecha.co.za"

RUN bash steamcmd \
	+@sSteamCmdForcePlatformType windows \
	+login anonymous \
	+force_install_dir "${STEAMAPPDIR}" \
	+app_update "${STEAMAPP_ID}" validate \
	+quit

CMD ["bash", "entry.sh"]