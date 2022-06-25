FROM ubuntu:focal

### change the system source for installing libs
ARG USE_SRC_INSIDE=true
RUN if [ ${USE_SRC_INSIDE} == true ] ; \
    then \
        sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list ; \
        sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list ; \
        echo "Use aliyun source for installing libs" ; \
    else \
        echo "Keep the download source unchanged" ; \
    fi
    
RUN dpkg --add-architecture i386 \
    && apt update \
    && apt install -y wine64 wine32 wget unzip xvfb \
    && mkdir -p /root/.wine/drive_c/steamcmd \
    && mkdir -p /root/.wine/drive_c/users/root/AppData/LocalLow/'Stunlock Studios'/VRisingServer/Settings \
    && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip -P /root/.wine/drive_c/steamcmd/ \
    && cd /root/.wine/drive_c/steamcmd/ \
    && unzip steamcmd.zip \
    && mkdir -p /root/.wine/drive_c/VRisingServer/ \
    && cd /root/.wine/drive_c/steamcmd 

COPY root .

WORKDIR /scripts

RUN chmod +x ./run.sh

EXPOSE 27015/udp
EXPOSE 27016/udp

CMD ./run.sh
