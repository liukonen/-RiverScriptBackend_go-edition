
FROM golang:1.27-alpine@sha256:70bd7ddea8b6cbe5d6943cde279d6b67feb10cc924fb9100d1d8757c1575b280 AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
COPY *.rive ./
COPY static/ ./static/
RUN CGO_ENABLED=0 go build -ldflags "-s -w -extldflags '-static'" -o /docker-gs-ping


FROM gcr.io/distroless/static-debian13:nonroot@sha256:aafe993665bf6200db38a02c11a9351e782a84b6a45e7f33b6695638c88e3931
COPY --from=build /docker-gs-ping /docker-gs-ping
COPY --from=build /app/*.rive /
COPY --from=build /app/static /static
EXPOSE 5000
ENTRYPOINT ["/docker-gs-ping"]