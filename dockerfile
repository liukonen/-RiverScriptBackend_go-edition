
FROM golang:1.27-alpine@sha256:eb61c3873c97416fff0116553fff65d67a3549f72e11d9758849a689cdd8b523 AS build
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