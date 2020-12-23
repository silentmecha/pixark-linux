#!/bin/bash
docker rm --force pixark-server
docker volume create pixark-server_data
docker run -dit --name=pixark-server --env-file .env -v pixark-server_data:/home/steam/PixARK-dedicated/ShooterGame/Saved -p 27015:27015/udp -p 27016:27016/udp -p 27017:27017/tcp -p 27018:27018/tcp silentmecha/pixark-linux:latest