
FROM golang:1.27-alpine@sha256:d200d2dd76b03a99b52651fd1325aff7dcd35422c35c01bac56571b0507f3deb AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
COPY *.rive ./
COPY static/ ./static/
RUN CGO_ENABLED=0 go build -ldflags "-s -w -extldflags '-static'" -o /docker-gs-ping


FROM gcr.io/distroless/static-debian13:nonroot@sha256:15f8637509792e05b97d83451b0b6ccfa4abd548f997e406ac1e72c87fe1fa78
COPY --from=build /docker-gs-ping /docker-gs-ping
COPY --from=build /app/*.rive /
COPY --from=build /app/static /static
EXPOSE 5000
ENTRYPOINT ["/docker-gs-ping"]