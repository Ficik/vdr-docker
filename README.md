# VDR in docker

plugins:
- live
- epgsearch
- streamdev-server
- robotv

## Install

1. install docker and docker-compose
2. clone this repo
3. check config, especially allowed hosts for streamdev-server and robotv
4. run `docker-compose up`

You should have live running on http port 8008 and streamdev-server on http 3000.
Just don't access streamdev-server using localhost, instead use your lan address.

## Scan channels

`docker-compose run vdr w_scan -o 21 > config/channels.conf`
