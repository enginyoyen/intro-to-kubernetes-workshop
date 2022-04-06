# 01 - Creating Docker Image

## Add Docker file
1. Fork Repository https://github.com/enginyoyen/kuard
2. Add File > Create new file
3. Name > Dockerfile 
4. Edit Dockerfile as described below
5. Commit


## Content of the Dockerfile
Stage 1 : Add base image for build purposes

```
FROM golang:1.12-alpine AS build
```


Install Node and NPM.
```
RUN apk update && apk upgrade && apk add --no-cache git nodejs bash npm
```

Get dependencies for Go part of build
```
RUN go get -u github.com/jteeuwen/go-bindata/...
```

```
WORKDIR /go/src/github.com/kubernetes-up-and-running/kuard
```

Copy all sources in
```
COPY . .
```

This is a set of variables that the build script expects
```
ENV VERBOSE=0
ENV PKG=github.com/kubernetes-up-and-running/kuard
ENV ARCH=amd64
ENV VERSION=test
```


Do the build. Script is part of incoming sources.
```
RUN build/build.sh
```


STAGE 2: Runtime
```
FROM alpine
```

Set user and copy binaries
```
USER nobody:nobody
COPY --from=build /go/bin/kuard /kuard
```


Provide defaults for an executing container
```
CMD [ "/kuard" ]
```