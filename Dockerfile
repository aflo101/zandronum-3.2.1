FROM ubuntu:22.04




ENV DEBIAN_FRONTEND=noninteractive




RUN apt-get update && \
    apt-get install -y \
        wget \
        bzip2 \
        ca-certificates \
        libsdl1.2debian \
        libjpeg-turbo8 \
        libssl3 \
        libopenal1 \
        libsqlite3-0 \
        libcurl4 \
        && rm -rf /var/lib/apt/lists/*




# Create the zandronum home dir (optional – keep if you want /home/zandronum)
RUN useradd -m zandronum




# Run the process as root instead of zandronum
USER root
WORKDIR /home/zandronum




# Download Zandronum 3.2.1 (64-bit Linux)
RUN wget -O zandronum-dedicated.tar.bz2 \
      "https://zandronum.com/downloads/zandronum3.2.1-linux-x86_64.tar.bz2" && \
    tar -xjf zandronum-dedicated.tar.bz2 && \
    rm zandronum-dedicated.tar.bz2




# Expect wads + config mounted here
RUN mkdir -p /home/zandronum/wads /home/zandronum/config




VOLUME ["/home/zandronum/wads", "/home/zandronum/config"]








# ---- Configurable defaults (Co-op Doom 2) ----
ENV Z_PORT=10667
ENV Z_IWAD=/home/zandronum/wads/DOOM2.WAD
ENV Z_MAXLIVES=0
ENV Z_MAXCLIENTS=8
ENV Z_MAXPLAYERS=8
ENV Z_DMFLAGS=4
ENV Z_HOSTNAME="FloMedia Doom2 Co-op"
ENV Z_PASSWORD=""
ENV Z_JOINPASSWORD=""
ENV Z_MAP=MAP01
# 0 = coop, 1 = DM, etc.
ENV Z_GAMETYPE=0
ENV Z_LOGFILE=/home/zandronum/config/server.log


# NEW: RCON password (override in compose: Z_RCONPASSWORD=yourpass)
ENV Z_RCONPASSWORD=""


# Default command – tweak flags as you like
CMD ["/bin/sh", "-c", "exec /home/zandronum/zandronum-server \
  -host \
  -port \"$Z_PORT\" \
  -iwad \"$Z_IWAD\" \
  +sv_maxlives \"$Z_MAXLIVES\" \
  +alwaysapplydmflags 1 \
  -skill 4 \
  +cooperative 0 \
  +sv_maprotation 0 \
  +sv_randommaprotation 0 \
  +sv_motd \"\" \
  +sv_hostemail \"\" \
  +sv_hostname \"$Z_HOSTNAME\" \
  +sv_website \"\" \
  +sv_password \"$Z_PASSWORD\" \
  +sv_forcepassword 0 \
  +sv_joinpassword \"$Z_JOINPASSWORD\" \
  +sv_forcejoinpassword 0 \
  +sv_rconpassword \"$Z_RCONPASSWORD\" \
  +sv_broadcast 0 \
  +sv_updatemaster 0 \
  +sv_maxclients \"$Z_MAXCLIENTS\" \
  +sv_maxplayers \"$Z_MAXPLAYERS\" \
  -upnp \
  +dmflags \"$Z_DMFLAGS\" \
  +dmflags2 0 \
  +zadmflags 0 \
  +compatflags 0 \
  +zacompatflags 0 \
  +lmsallowedweapons 0 \
  +lmsspectatorsettings 0 \
  +sv_afk2spec 0 \
  +sv_coop_damagefactor 1 \
  +sv_defaultdmflags 0 \
  +sv_allowprivatechat 1 \
  +sv_country automatic \
  +map $Z_MAP \
  +sv_gametype \"$Z_GAMETYPE \" \
  +logfile \"$Z_LOGFILE\""]
