# silentmecha/pixark-linux

This repository contains the files needed for the image silentmecha/pixark-linux:latest

## Usage

### [build.sh](build.sh)
This is used to build the image locally. This will also pull [silentmecha/steamcmd-wine:latest](https://registry.hub.docker.com/r/silentmecha/steamcmd-wine) from Docker Hub if not found locally. Alternitively this can be build from [source](https://github.com/silentmecha/steamcmd-wine)
### [update.sh](update.sh)
This is used to update the image locally. This will pull [silentmecha/pixark-linux:latest](https://registry.hub.docker.com/r/silentmecha/pixark-linux) from Docker Hub if not found locally. Alternitively this can be build from using [build.sh](#build.sh)
### [run.sh](run.sh)
This is used to run the built [silentmecha/pixark-linux:latest](https://registry.hub.docker.com/r/silentmecha/pixark-linux) image. You will need to rename the [.env.example](.env.example) file to `.env` and edit the variables to your liking. For variable explination please see [here](#environment-variables). If deploying more than one server please edit this file and replace all instances of `pixark-server` with a different name to prevent clashes. Also insure that the [ports](#ports) are different as to prevent any port binding issues.

### Environment Variables

| Variable Name       | Default Value   | Description                                                                  |
| ------------------- | --------------- | ---------------------------------------------------------------------------- |
| MAP                 | CubeWorld_Light |                                                                              |
| SESSIONNAME         | SessionName     | Name of your server as seen in server browser (Accepts spaces)               |
| SERVERPASSWORD      |                 | Password to enter your server                                                |
| SERVERADMINPASSWORD | ChangeMe        | Admin access password (also know as RCON password)                           |
| MAXPLAYERS          | 20              | Maximum number of players                                                    |
| RCONENABLED         | True            | Enable RCON access (will default to false if `SERVERADMINPASSWORD` is blank) |
| PORT                | 27015           | Port used to connect to the server                                           |
| QUERYPORT           | 27016           | Port used to query the server                                                |
| CUBEPORT            | 27018           | Port used to send world data                                                 |
| RCONPORT            | 27017           | Port for RCON connections                                                    |
| CULTUREFORCOOKING   | en              | Must be specified. 'en' for English                                          |
| CUBEWORLD           | cubeworld       | Name of the folder where your save will go                                   |
| ADDITIONAL_ARGS     |                 | Currently not used                                                           |

### Ports
Currently the following ports are used.

| Port      | Default |
| --------- | ------- |
| PORT      | 27015   |
| QUERYPORT | 27016   |
| CUBEPORT  | 27018   |
| RCONPORT  | 27017   |

All these ports need to be forwarded through your router except for `RCONPORT` unless you wish to externally RCON into the server. 

## Notes
Currently this is based off of Ubuntu 18.04 as there are known issues with steamcmd and Ubuntu 20.04. Once Ubuntu 20.04 is stable I will update the images

## License

[MIT license](LICENSE)