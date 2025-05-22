# Building the binary of the App
FROM golang:1.19 AS build

WORKDIR /go/src/tasky
COPY . .
RUN go mod download
RUN echo "Listing contents..." && ls -lah && echo "Running go build..." && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -x -o /go/src/tasky/tasky

FROM alpine:3.17.0 AS release

WORKDIR /app
COPY --from=build  /go/src/tasky/tasky .
COPY --from=build  /go/src/tasky/assets ./assets
EXPOSE 8080
ENTRYPOINT ["/app/tasky"]


