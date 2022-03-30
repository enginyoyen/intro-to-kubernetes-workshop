FROM tsl0922/ttyd as ttyd
FROM mcr.microsoft.com/azure-cli 

COPY --from=ttyd /usr/bin/ttyd /usr/bin/ttyd

RUN az aks install-cli

RUN apk add --no-cache bash tini
EXPOSE 8080
WORKDIR /root

ENTRYPOINT ["/sbin/tini", "--"]
CMD ttyd -p 8080 -c $CREDENTIAL bash