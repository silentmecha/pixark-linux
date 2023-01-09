FROM silentmecha/pixark-linux:base

LABEL maintainer="silent@silentmecha.co.za"

RUN bash steamcmd \
	+@sSteamCmdForcePlatformType windows \
	+force_install_dir "${STEAMAPPDIR}" \
	+login anonymous \
	+app_update "${STEAMAPP_ID}" validate \
	+quit

CMD ["bash", "entry.sh"]