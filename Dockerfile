# Building the binary of the App
FROM golang:1.19 AS build

WORKDIR /go/src/tasky
COPY go.mod go.sum ./
RUN go mod download
COPY . .
# Show directory contents to verify files are copied
RUN echo "===== FILES IN /go/src/tasky =====" && ls -lah /go/src/tasky

# Show main.go contents (to confirm it exists)
RUN echo "===== CONTENTS OF main.go =====" && cat /go/src/tasky/main.go || echo "main.go not found!"

# Run go build in its own step to capture detailed logs
RUN echo "===== RUNNING GO BUILD =====" && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -x -o /go/src/tasky/tasky

FROM alpine:3.17.0 AS release

WORKDIR /app
COPY --from=build  /go/src/tasky/tasky .
COPY --from=build  /go/src/tasky/assets ./assets
EXPOSE 8080
ENTRYPOINT ["/app/tasky"]


