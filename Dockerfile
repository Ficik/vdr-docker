# -----------------------------------------------------------------------------
# docker-vdr
#
#
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------

FROM ubuntu:14.04
MAINTAINER ficik <standa.fifik@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive \
    HOME=/root

RUN echo APT::Install-Recommends "0"; >> /etc/apt/apt.conf && \
    echo APT::Install-Suggests "0"; >> /etc/apt/apt.conf && \
    DEBIAN_FRONTEND=noninteractive apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install git \
            w-scan dvb-apps gettext python curl \
  build-essential libjpeg-dev libncursesw5-dev libfreetype6-dev libboost-all-dev \
  libcap-dev libfontconfig-dev linux-libc-dev libfribidi-dev libncurses5-dev \
  libudev-dev libcurl4-nss-dev \
  libtnt-dev libtntnet-dev libpcre3-dev && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# MERGE THESE RUNS

RUN git clone https://github.com/chrodriguez/vdr.git /vdr && \
  git clone http://projects.vdr-developer.org/git/vdr-plugin-live.git /vdr/PLUGINS/src/live && \
  git clone https://github.com/pipelka/vdr-plugin-robotv.git /vdr/PLUGINS/src/robotv && \
  git clone https://projects.vdr-developer.org/git/vdr-plugin-epgsearch.git/ /vdr/PLUGINS/src/epgsearch && \
  git clone https://projects.vdr-developer.org/git/vdr-plugin-streamdev.git /vdr/PLUGINS/src/streamdev && \
  git clone https://projects.vdr-developer.org/git/vdr-plugin-epgfixer.git /vdr/PLUGINS/src/epgfixer

# MERGE THESE RUNS

RUN apt-get update && apt-get -y install groff-base bsdmainutils

RUN  cd /vdr && \
  VIDEODIR=/recordings make && \
  VIDEODIR=/recordings make install && \
  mkdir -p /usr/local/share/vdr/plugins/ && \
  cp -r /vdr/PLUGINS/src/live/live/ /usr/local/share/vdr/plugins/live/

# UNCOMMENT AND MERGE THESE RUNS

#  rm -fr /vdr && \
#  DEBIAN_FRONTEND=noninteractive apt-get -y remove build-essential libjpeg-dev libncursesw5-dev libfreetype6-dev \
#  libcap-dev libfontconfig-dev linux-libc-dev libfribidi-dev libncurses5-dev \
#  libudev-dev curl libcurl4-nss-dev libboost-all-dev \
#  libtnt-dev libtntnet-dev libpcre3-dev git

COPY docker-entrypoint.sh /entrypoint.sh

# Expose Ports
EXPOSE 34890 34892 3000 8008

# Volumes
VOLUME /var/lib/vdr
VOLUME /recordings


ENTRYPOINT ["/entrypoint.sh"]
# Use baseimage-docker's init system
CMD ["-p", "6419", "-P", "live", "-P", "robotv", "-P", "streamdev-server", "-P", "epgfixer"]
