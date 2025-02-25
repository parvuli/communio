FROM ubuntu:22.04 AS build-stage
WORKDIR /communio
RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y ca-certificates git make wget build-essential

RUN wget https://dl.google.com/go/go1.23.4.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN VERSION=0.0 && \
    COMMIT=$(git log -1 --format='%H') && \
    ldflags='-X github.com/cosmos/cosmos-sdk/version.Name=communio \
        -X github.com/cosmos/cosmos-sdk/version.ServerName=communiod \
        -X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
        -X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT) \
        -X "github.com/cosmos/cosmos-sdk/version.BuildTags=netgo,"' && \
    GOOS=linux GOARCH=amd64 CGO_ENABLED=1 go build -mod=readonly -tags netgo -ldflags "${ldflags}" -o /tmp ./cmd/communiod

FROM scratch AS export-stage
COPY --from=build-stage /tmp/communiod /communiod
