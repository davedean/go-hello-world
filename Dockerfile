# use golang base for building
FROM golang:alpine as builder

WORKDIR /app
ADD ./src/http/ /app

RUN go build -o http-server hello-http.go

# golang again for running
FROM golang:alpine

WORKDIR /app
COPY --from=builder /app/http-server /app/http-server

EXPOSE 8080

CMD ["/app/http-server"]
