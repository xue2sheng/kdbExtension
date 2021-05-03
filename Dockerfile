FROM gcc:latest
WORKDIR /root
COPY . /root
# adding nameserver because my local env is not correctly configured
RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf && \
    apt-get update && \
    apt-get install -y cmake neovim
# libboost-dev probably needed in more complex examples
