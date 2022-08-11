FROM alpine:3.16

COPY entrypoint.sh /

RUN apk add --no-cache bash file \
    && echo 'set -o noglob' > /etc/profile.d/bash_noglob.sh \
    && chmod +x /entrypoint.sh 

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
