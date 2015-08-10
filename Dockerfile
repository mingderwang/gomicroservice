
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

# Godep for vendoring
RUN go get github.com/tools/godep
# Recompile the standard library without CGO
RUN CGO_ENABLED=0 go install -a std

MAINTAINER dahernan@gmail.com
ENV APP_DIR $GOPATH/src/github.com/mingderwang/muzha-project/yeoman/muzha/gomicroservice
 
# Set the entrypoint 
ENTRYPOINT ["/opt/app/gomicroservice"]
ADD . $APP_DIR

# Compile the binary and statically link
RUN mkdir /opt/app
RUN cd $APP_DIR && godep restore
RUN cd $APP_DIR && CGO_ENABLED=0 go build -o /opt/app/gomicroservice -ldflags '-w -s'

EXPOSE 3001
