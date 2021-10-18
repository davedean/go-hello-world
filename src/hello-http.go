package main

import (
    "log"
    "fmt"
    "net/http"
    "time"
    "os"
)

// Set a global for run mode
var runningMode = "Unknown"

func main() {

    helloWorldEnvironment, ok := os.LookupEnv("HELLO_WORLD_ENV")

    if ok {
        switch helloWorldEnvironment {
            case "LCL" : runningMode = "Local"
            case "DEV" : runningMode = "Development"
            case "TST" : runningMode = "Testing"
            case "STG" : runningMode = "Staging"
            case "PRD" : runningMode = "Production"
            default : runningMode = "Development"
        }
    } else {
        runningMode = "Undefined"
    }

    // Log startups to stdout
    fmt.Println(niceTime(), "Server start in", runningMode, "configuration.")

    // Define our "endpoints"
    http.HandleFunc("/", HandlerDefault)
    http.HandleFunc("/health", HandlerHealth)

    // Create the server
    httpServer := &http.Server{
        // Set our listen port - 8080 to not require privs
        Addr: ":8080",
        // Set timeouts
        // Recommended from: https://blog.cloudflare.com/exposing-go-on-the-internet/
        ReadTimeout: 5 * time.Second,
        WriteTimeout: 10 * time.Second,
        IdleTimeout:  120 * time.Second,
    }

    // Start HTTP server and listen
    log.Fatal(httpServer.ListenAndServe())

}

func Hello(Helloname string) string {
    // Small testable function

    Hellostring := "Hello, " + Helloname

    return Hellostring
}


func Health() string {
    // Small testable function - static output
    outputString := "OK - 200 - " + runningMode
    return outputString
}

func HandlerDefault(w http.ResponseWriter, r *http.Request) {

    var Helloname string

    // On '/' say 'World'
    if r.RequestURI == "/" {
        Helloname = "World"
    } else {
    // Otherwise repeat the input, minus the slash
    // eg: for /foo -> "Hello, foo"
        Helloname = (r.RequestURI)[1:]
    }

    // Output to handler
    fmt.Fprintf(w, Hello(Helloname))

    // "Log" output to stdout
    fmt.Println(niceTime(), "Served ", Helloname)
}

func HandlerJason(w http.ResponseWriter, r *http.Request) {
    // Meme compliant response: https://imgflip.com/meme/243172133/Say-Jarvis
    // Output to handler
    fmt.Fprintf(w, "Say, Jarvis, how much do you know about bitcoin?")

    // "Log" output to stdout
    fmt.Println(niceTime(), "Served /Jason")
}

func HandlerHealth(w http.ResponseWriter, r *http.Request) {
    // Output to handler
    fmt.Fprintf(w, Health())

    // "Log" output to stdout
    fmt.Println(niceTime(), "Served /health")
}

func niceTime () string {
    // RFC3339 - https://www.ietf.org/rfc/rfc3339.txt
    // Example: 2021-10-15T13:16:23+11:00 Server start
    timeString := time.Now().Format(time.RFC3339)
    return timeString
}
