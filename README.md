# silentmecha/pixark-linux

This repository contains the files needed for the image silentmecha/pixark-linux:latest

## Usage

This stack uses an image from [atmoz](https://github.com/atmoz). To see more on the image used visit their github [https://github.com/atmoz/sftp](https://github.com/atmoz/sftp).

For more info on environment variables and what they do see [Environment Variables](#environment-variables)

### Simplest Method

The simplest usage for this is using the `docker-compose` method.

```console
git clone https://github.com/silentmecha/pixark-linux.git pixark-server
cd pixark-server
cp .env.example .env
nano .env
docker-compose up -d
```

### Without building the image locally

```console
git clone https://github.com/silentmecha/pixark-linux.git pixark-server
cd pixark-server
cp .env.example .env
nano .env
docker-compose pull
docker-compose up -d
```

### Updating

Updating is still currently in development so once that is sorted this README will be updated. The idea is to allow an image to be updated without needing to either download the full image or rebuilding the image

### Environment Variables

| Variable Name        | Default Value   | Description                                                                                        |
| -------------------- | --------------- | -------------------------------------------------------------------------------------------------- |
| MAP                  | CubeWorld_Light | Type of map to play on currently there is only two options `CubeWorld_Light` and `SkyPiea_Light`   |
| SESSIONNAME          | SessionName     | Name of your server as seen in server browser (accepts spaces)                                     |
| SERVERPASSWORD       |                 | Password to enter your server                                                                      |
| SERVERADMINPASSWORD  | ChangeMe        | Admin access password (also know as RCON password)                                                 |
| MAXPLAYERS           | 20              | Maximum number of players                                                                          |
| RCONENABLED          | True            | Enable RCON access (will default to false if `SERVERADMINPASSWORD` is blank)                       |
| PORT                 | 27015           | Port used to connect to the server                                                                 |
| QUERYPORT            | 27016           | Port used to query the server                                                                      |
| CUBEPORT             | 27018           | Port used to send world data                                                                       |
| RCONPORT             | 27017           | Port for RCON connections                                                                          |
| CULTUREFORCOOKING    | en              | Must be specified. 'en' for English                                                                |
| MAPSEED              |                 | Custom map seed in numbers (do not use 0)                                                          |
| CUBEWORLD            | cubeworld       | Name of the folder where your generated map will go                                                |
| ALTSAVEDIRECTORYNAME |                 | Name of the folder where your saved data and configs will go                                       |
| CLUSTERID            |                 | The variable that defines your cluster of servers to be linked see [Cluster Setup](#cluster-setup) |
| ADDITIONAL_ARGS      |                 | Currently not used                                                                                 |
| SFT_USER             | foo             | Username for SFTP access to edit save data                                                         |
| SFT_PASS             | pass            | Password for SFTP access to edit save data                                                         |
| SFT_PORT             | 2222            | Port for SFTP access (should not be 22 )                                                           

For more info on the usage of SFTP see [here](https://github.com/atmoz/sftp). If you do not want to use a plane text password see [encrypted-password](https://github.com/atmoz/sftp#encrypted-password)

### Ports
Currently the following ports are used.

| Port      | Default |
| --------- | ------- |
| PORT      | 27015   |
| QUERYPORT | 27016   |
| CUBEPORT  | 27018   |
| RCONPORT  | 27017   |
| SFT_PORT  | 2222    |

All these ports need to be forwarded through your router except for `RCONPORT` and `SFT_PORT` unless you wish to externally RCON into the server or remotely edit the save data.

**NB PixARK does not like port remapping `eg. -p 28015:27015/udp`**

## Cluster Setup

In order to configure clusters that allow players to travel between your servers you will need to give all servers in the cluster the same `CLUSTERID` and set both `CUBEWORLD` and `ALTSAVEDIRECTORYNAME` to unique names. You will also need to uncomment the last line in the [docker-compose.yml](docker-compose.yml) file.

## Notes
The cluster function is not properly documented so I am not sure exactly how it should function so this is still under experiment.

## License

[MIT license](LICENSE)