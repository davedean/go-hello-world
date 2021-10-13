# use golang base for building
FROM golang:latest as builder

RUN mkdir /app
ADD ./src/hello-http.go /app
WORKDIR /app

RUN go build -o http-server hello-http.go


# golang again for running
FROM golang:latest

RUN mkdir /app
WORKDIR /app
COPY --from=builder /app/http-server /app/http-server

EXPOSE 8080

CMD ["/app/http-server"]
