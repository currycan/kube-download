FROM alpine:3

LABEL maintainer="andrew <ansandy@foxmail.com>"

ENV LANG=C.UTF-8

ENV user=normal
ENV group=normal
ENV uid=9001
ENV gid=9001
RUN set -ex; \
  addgroup -S -g ${gid} ${group} && adduser -S -D -G ${group} -u ${uid} ${user} -s /bin/bash; \
  apk add --update --no-cache sudo; \
  echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${user}; \
  chmod 0440 /etc/sudoers.d/${user}; \
  echo 'export PS1="\u@\h:\w\$ "' >> ~/.bashrc; \
  cp -a /root/.bashrc /home/${user}/.bashrc; \
  chown -R ${uid}:${gid} /home/${user}/.bashrc; \
  rm -rf /tmp/* /var/cache/apk/*;

ENV TZ=Asia/Shanghai
RUN set -ex; apk -U upgrade; apk add --update --no-cache \
    bash \
    tzdata \
    curl \
    su-exec \
    ca-certificates \
    gcompat \
    jq \
    tini; \
  update-ca-certificates; \
  ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime; \
  echo ${TZ} > /etc/timezone; \
  rm -rf /var/cache/apk/*

# # glibc
# ENV GLIBC_VERSION=2.35-r1
RUN set -ex; \
  apk add --update --no-cache libstdc++; \
  wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub; \
  for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; \
  do \
    curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; \
  done; \
  apk add /tmp/*.apk; \
  ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ); \
  echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh; \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib; \
  /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8; \
  apk del --no-network glibc-i18n; \
  rm -rf /tmp/* /var/cache/apk/*

# ENV FILEBEAT_VERSION=7.17.15
# # Install filebeat
# RUN wget -q -O /tmp/filebeat.tar.gz https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz \
#     && cd /tmp \
#     && tar xzvf filebeat.tar.gz \
#     && cd filebeat-* \
#     && cp filebeat /bin \
#     && mkdir -p /etc/filebeat \
#     && cp filebeat.yml /etc/filebeat/filebeat.example.yml \
#     && rm -rf /tmp/filebeat*

CMD [ "/bin/bash" ]
