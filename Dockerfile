FROM alpine:3.21

ENV \
   TERM=xterm-color \
   TZ=Europe/Riga \
   APP_UID=1001 \
   APP_GID=1001

COPY --chown=root:wheel --chmod=755 files/init files/init-root /

RUN \
   apk add --update --no-cache ca-certificates dumb-init su-exec tzdata && \
   addgroup -g ${APP_GID} app && adduser -D -G app -s /bin/ash -u ${APP_UID} app && \
   chown -R app:app /srv && \
   ln -s /usr/share/zoneinfo/Europe/Riga /etc/localtime

WORKDIR /srv

ENTRYPOINT [ "/init" ]
