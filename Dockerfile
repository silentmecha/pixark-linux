FROM silentmecha/steamcmd-wine:latest

LABEL maintainer="silent@silentmecha.co.za"

ENV STEAMAPP_ID 824360
ENV STEAMAPP PixARK
ENV STEAMAPPDIR "${HOME}/${STEAMAPP}-dedicated"
ENV STEAM_BACKUPDIR "${STEAM_SAVEDIR}/backup"
ENV STEAM_SAVEDIR "${STEAMAPPDIR}/ShooterGame/Saved"

USER root

COPY ./src/entry.sh ${HOME}/entry.sh

RUN set -x \
	&& mkdir -p "${STEAMAPPDIR}" \
    && mkdir -p "${HOME}/mcrcon" \
    && wget -c https://github.com/Tiiffi/mcrcon/releases/download/v0.7.1/mcrcon-0.7.1-linux-x86-64.tar.gz -O - | tar -xz -C "${HOME}/mcrcon" --strip-components=1\
	&& mkdir -p "${STEAM_SAVEDIR}" \
	&& chmod +x "${HOME}/entry.sh" \
	&& chown -R "${USER}:${USER}" "${HOME}/entry.sh" "${STEAMAPPDIR}" \
	&& chmod -R 744 "${STEAM_SAVEDIR}"

ENV MAP=CubeWorld_Light\
	SESSIONNAME=SessionName \
	SERVERPASSWORD= \
	SERVERADMINPASSWORD=ChangeMe \
	MAXPLAYERS=20 \
	PORT=27015 \
	QUERYPORT=27016 \
	CUBEPORT=27018 \
	RCONPORT=27017 \
	RCONENABLED=True \
	CULTUREFORCOOKING=en \
	CUBEWORLD=cubeworld \
	CLUSTERID= \
	ALTSAVEDIRECTORYNAME= \
	MAPSEED= \
	ADDITIONAL_ARGS=

# Switch to user
USER ${USER}

RUN bash steamcmd \
	+@sSteamCmdForcePlatformType windows \
	+force_install_dir "${STEAMAPPDIR}" \
	+login anonymous \
	+app_update "${STEAMAPP_ID}" validate \
	+quit

# ENV STEAMAPP_BUILDID $(grep buildid < "${STEAMAPPDIR}/steamapps/appmanifest_${STEAMAPP_ID}.acf" | sed 's/"buildid"//' | xargs)

VOLUME "${STEAM_SAVEDIR}"

WORKDIR ${HOME}

EXPOSE 	${PORT}/udp \
        ${QUERYPORT}/udp \
        ${RCONPORT}/tcp \
        ${CUBEPORT}/tcp


CMD ["bash", "entry.sh"]
