FROM ubuntu:trusty

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

RUN mkdir /ravendark

RUN wget -qO- https://github.com/raven-dark/bins/raw/master/raven-dark-0.2.1-ubuntu-rc2.tar.gz | tar xvz -C /ravendark

RUN chmod +x /ravendark/ravendarkd
RUN chmod +x /ravendark/ravendark-cli

RUN apt-get autoclean && \
  apt-get autoremove -y

RUN mkdir -p /root/data
RUN mkdir -p /root/conf

COPY ravendark.conf /root/conf/ravendark.conf

VOLUME /root/data

# sentinel
RUN apt-get install python3-pip -y;
RUN pip3 install virtualenv;
RUN cd ~ && \
  git clone https://github.com/raven-dark/sentinel.git && cd sentinel && \
  virtualenv ./venv && \
  ./venv/bin/pip install -r requirements.txt && \
  echo "* * * * *    root    cd /root/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1" >> /etc/crontab

WORKDIR /ravendark

COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh

#6666 is p2p
EXPOSE 6666

ENTRYPOINT ["./entrypoint.sh"]
