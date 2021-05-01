FROM gcc:latest
RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf && \
    apt-get update && apt-get install -y cmake neovim
