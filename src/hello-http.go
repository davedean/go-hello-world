package main

import (
    "fmt"
    "net/http"
    "time"
)

func main() {

    http.HandleFunc("/", HandlerDefault)
    http.HandleFunc("/health", HandlerHealth)

    http.ListenAndServe(":8080", nil)
}

func Hello(Helloname string) string {
    Hellostring := "Hello, " + Helloname
    return Hellostring
}

func Health() string {
    return "OK - 200"
}

func HandlerDefault(w http.ResponseWriter, r *http.Request) {
        var Helloname string
        if r.RequestURI == "/" {
            Helloname = "World"
        } else {
            Helloname = (r.RequestURI)[1:]
        }
        fmt.Fprintf(w, Hello(Helloname))
        fmt.Println(niceTime(), "Served ", Helloname)
}

func HandlerHealth(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, Health())
        fmt.Println(niceTime(), "Served /health")
}

func niceTime () string {
    timeString := time.Now().Format(time.RFC3339)
        return timeString
}
