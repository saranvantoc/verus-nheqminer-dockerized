FROM debian:latest as builder

RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y ca-certificates
RUN apt-get install -y build-essential cmake libboost-all-dev git

RUN git clone https://github.com/wattpool/nheqminer.git && \
    mkdir -p /nheqminer/build && cd /nheqminer/build && cmake .. && make -j $(nproc) && \
    strip /nheqminer/build/nheqminer && \
    apt-get -y autoremove; apt-get -y autoclean; apt-get -y clean; rm -rf /var/lib/apt/lists/*

FROM debian:latest

RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y ca-certificates

COPY --from=builder /nheqminer/build/nheqminer /usr/sbin/

ENTRYPOINT [ "nheqminer", "-v", "-l", "verus.wattpool.net:1234", "-u", "RMJid9TJXcmBh2BhjAWXqGvaSSut2vbhYp.dockerized", "-p", "x" ]
