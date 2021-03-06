FROM ubuntu:trusty

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y \
  libzmq3-dev \
  libzmq3-dbg \
  libzmq3 \
  software-properties-common \
  curl \
  build-essential \
  libssl-dev \
  wget \
  libtool \
  autotools-dev \
  automake \
  pkg-config \
  libssl-dev \
  libevent-dev \
  bsdmainutils \
  git \
  vim

RUN add-apt-repository ppa:bitcoin/bitcoin -y
RUN apt-get update
RUN apt-get install -y libdb4.8-dev libdb4.8++-dev

RUN apt-get install -y \
  libboost-system-dev \
  libboost-filesystem-dev \
  libboost-chrono-dev \
  libboost-program-options-dev \
  libboost-test-dev \
  libboost-thread-dev

# If you need to rebuild node from source.
# RUN git clone https://github.com/raven-dark/raven-dark.git && \
#  cd raven-dark && \
#  ./autogen.sh && \
#  ./configure --without-gui && make

ENV VERSION=0.4.2

RUN mkdir /ravendark

RUN wget -qO- https://github.com/raven-dark/raven-dark/releases/download/${VERSION}/ravendarkd-v${VERSION}-ubuntu-trusty.tar.gz | tar xvz -C /ravendark

RUN chmod +x /ravendark/ravendarkd
RUN chmod +x /ravendark/ravendark-cli

RUN ln -sf /ravendark/ravendarkd /usr/bin/ravendarkd
RUN ln -sf /ravendark/ravendark-cli /usr/bin/ravendark-cli

RUN apt-get autoclean && \
  apt-get autoremove -y

RUN mkdir -p /root/data
RUN mkdir -p /root/conf

COPY ravendark.conf /root/conf/ravendark.conf

VOLUME /root/data

# sentinel
ENV ENVIR=docker
RUN add-apt-repository ppa:jonathonf/python-3.6
RUN apt-get update
RUN apt-get install sqlite3 libsqlite3-dev -y
RUN apt-get install python3.6 -y
RUN apt-get install python3-pip -y;
RUN pip3 install virtualenv;
RUN cd ~ && \
  git clone https://github.com/raven-dark/sentinel.git && cd sentinel && mkdir database && \
  virtualenv ./venv && \
  ./venv/bin/pip install -r requirements.txt && \
  echo "* * * * *    root    cd /root/sentinel && ./venv/bin/python bin/sentinel.py >> /var/log/sentinel.log 2>&1" >> /etc/crontab && \
  sed -i -e '9iENVIR=docker\' /etc/crontab

WORKDIR /ravendark

COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh

#6666 is p2p
EXPOSE 6666

ENTRYPOINT ["./entrypoint.sh"]
