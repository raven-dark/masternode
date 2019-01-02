# RavenDark Masternode Docker Container

## Build

`sudo docker build -t ravendark-mn:latest .`

## Run

`sudo docker run -p 6666:6666 -v ~/data:/root/data -d --name ravendark-mn ravendark-mn:latest`
