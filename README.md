# RavenDark Masternode Docker Container

start up a vps. i recommend using aws and using a t2.nano or t3.nano instance with ubuntu. we don't cover setting up that server here. once you're logged into your new server on aws. install docker.

copy and paste:

`sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common vim && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && sudo apt-get update && sudo apt-get install -y docker-ce`

then:

`git clone https://github.com/raven-dark/masternode.git && cd masternode`

edit the `ravendark.conf` file and fill in your info.

`vi ravendark.conf` (use the arrow keys to navigate, push `i` to start editing)

(if you need help with `vi` google "how to use vim")

copy and paste your private key in place of `private-key-goes-here`, change your password and enter your ip address in place of `your.ip.goes.here`.

push `esc` to stop editing, then type `:wq` to write the file and quit the editor.

```
server=1
listen=1
daemon=1
staking=0
masternode=1
masternodeprivkey=private-key-goes-here
whitelist=127.0.0.1
txindex=1
addressindex=1
spentindex=1
timestampindex=1
logtimestamps=1
maxconnections=256
zmqpubrawtx=tcp://127.0.0.1:28332
zmqpubrawtxlock=tcp://127.0.0.1:28332
zmqpubhashblock=tcp://127.0.0.1:28332
rpcallowip=127.0.0.1
rpcuser=ravendark
rpcpassword=change-this
bind=0.0.0.0
externalip=your.ip.goes.here:6666
```

## Build

`sudo docker build -t ravendark-mn:latest .`

## Run

`sudo docker run -p 6666:6666 -v ~/data:/root/data -d --name ravendark-mn ravendark-mn:latest`


## Monitor

To watch the logs of the new masternode docker container

`sudo docker logs --tail 100 -f ravendark-mn`


### Update local desktop wallet
You'll then want to go to your desktop wallet, go to the settings tab on the right at the bottom and click "Open Masternod Configuration File".

Enter a line like the example.

`mn1 your.ip.goes.here:6666 master-node-private-key collateral-transaction-id transaction-index`



### Windows

The above should work but has not been tested. You will have to omit `sudo` from all commands. Follow the [Docker for Windows](https://docs.docker.com/docker-for-windows/) guide to get started. Make sure port `6666` is forwarded from your router to the computer you're running the masternode on.

### macOS

The above should work but has not been tested. You will have to omit `sudo` from all commands. Follow the [Docker for Mac](https://docs.docker.com/docker-for-mac/) guide to get started. Make sure port `6666` is forwarded from your router to the computer you're running the masternode on.
