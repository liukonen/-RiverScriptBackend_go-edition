
FROM golang:1.27-alpine@sha256:d200d2dd76b03a99b52651fd1325aff7dcd35422c35c01bac56571b0507f3deb AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
COPY *.rive ./
COPY static/ ./static/
RUN CGO_ENABLED=0 go build -ldflags "-s -w -extldflags '-static'" -o /docker-gs-ping


FROM gcr.io/distroless/static-debian13:nonroot@sha256:25ac8f0c3b2334a9eb05452266bd4697864a8c8ef0ef71e5e6480d7f92868329
COPY --from=build /docker-gs-ping /docker-gs-ping
COPY --from=build /app/*.rive /
COPY --from=build /app/static /static
EXPOSE 5000
ENTRYPOINT ["/docker-gs-ping"]