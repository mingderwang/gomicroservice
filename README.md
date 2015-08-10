#Test dockerize
main.go copyright from original developer.
#Pre-install
```go
go get github.com/dahernan/godockerize
go get github.com/tools/godep
wget https://github.com/docker-library/golang/blob/master/go-wrapper
```

#Build
To generate for Dockerfile
```
godep save
godockerize -expose 3001
```
then
```
docker build -t gomicroservice .
```
then
```
docker run --rm  -p 8080:8080  gomicroservice
```

#Workaround
if you can't download FROM golang:stable in the first Dockerfile
use following lines instead.
```
FROM buildpack-deps:jessie-scm

RUN apt-get update && apt-get install -y \
        gcc libc6-dev make \
                --no-install-recommends \
                    && rm -rf /var/lib/apt/lists/*

                    ENV GOLANG_VERSION 1.4.2

                    RUN curl -sSL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz \
                            | tar -v -C /usr/src -xz

                            RUN cd /usr/src/go/src && ./make.bash --no-clean 2>&1

                            ENV PATH /usr/src/go/bin:$PATH

                            RUN mkdir -p /go/src /go/bin && chmod -R 777 /go
                            ENV GOPATH /go
                            ENV PATH /go/bin:$PATH
                            WORKDIR /go

                            COPY go-wrapper /usr/local/bin/
```

#Workaround 2

if docker build fail, remove -d for the following line in Dockerfile

```
RUN cd $APP_DIR && CGO_ENABLED=0 go build -o /opt/app/gomicroservice -ldflags '-d -w -s'
```
