FROM alpine:3.17


RUN apk add --no-cache bash file findutils
    # && echo 'set -o noglob' > /etc/profile.d/bash_noglob.sh \
COPY entrypoint.bash bash-logger.bash /root/
RUN chmod +x /root/entrypoint.bash 

ENTRYPOINT ["/bin/bash", "/root/entrypoint.bash"]
