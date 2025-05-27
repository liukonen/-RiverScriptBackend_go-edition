FROM golang:1.24.3-alpine3.21 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./
COPY *.rive ./
ADD /static /app/static
RUN go build -ldflags "-s -w" -o /docker-gs-ping


## Deploy
FROM alpine:3.21.3
WORKDIR /
COPY --from=build /docker-gs-ping /docker-gs-ping
COPY *.rive /
ADD /static /static
EXPOSE 5000
USER 1000:1000
ENTRYPOINT ["/docker-gs-ping"]
