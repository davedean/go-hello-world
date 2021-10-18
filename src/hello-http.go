package main

import (
    "log"
    "fmt"
    "net/http"
    "time"
    "os"
)

// Set a global for run mode
var runningMode = setEnvironment(os.LookupEnv("HELLO_WORLD_ENV"))

func main() {

    // log startup
    outputLog("Server start in " + runningMode + " configuration.")

    // Define our "endpoints"
    http.HandleFunc("/", handlerDefault)
    http.HandleFunc("/health", handlerHealth)
    http.HandleFunc("/Jason", handlerJason)

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

func setEnvironment(helloWorldEnvironment string, ok bool) string {

    // Set to "Unknown" before we try to determine.
    runningMode := "Unknown"

    // if the lookup succeeds set the Environment
    if ok {
        // various short codes -> strings ..
        switch helloWorldEnvironment {
            case "LCL" : runningMode = "Local"
            case "DEV" : runningMode = "Development"
            case "TST" : runningMode = "Testing"
            case "STG" : runningMode = "Staging"
            case "PRD" : runningMode = "Production"
            default : runningMode = "Development"
        }
    } else {
        // if not defined, make that explicit ..
        runningMode = "Undefined"
    }

    return runningMode
}

func outputLog(logString string) {

    // RFC3339 - https://www.ietf.org/rfc/rfc3339.txt
    // Example: 2021-10-15T13:16:23+11:00 Server start
    timeString := time.Now().Format(time.RFC3339)

    // output to stdout
    fmt.Println(timeString, logString)
}

func hello(helloName string) string {
    // Small testable function

    helloString := "Hello, " + helloName

    return helloString
}


func health() string {
    // Small testable function - static output
    outputString := "OK - 200 - " + runningMode
    return outputString
}

func handlerDefault(w http.ResponseWriter, r *http.Request) {

    var helloName string

    // On '/' say 'World'
    if r.RequestURI == "/" {
        helloName = "World"
    } else {
    // Otherwise repeat the input, minus the slash
    // eg: for /foo -> "Hello, foo"
        helloName = (r.RequestURI)[1:]
    }

    // Output to handler
    fmt.Fprintf(w, hello(helloName))

    // log output
    outputLog("Served " + helloName)
}

func handlerJason(w http.ResponseWriter, r *http.Request) {
    // Meme compliant response: https://imgflip.com/meme/243172133/Say-Jarvis
    // Output to handler
    fmt.Fprintf(w, "Say, Jarvis, how much do you know about bitcoin?")

    // log output
    outputLog("Served /Jason")
}

func handlerHealth(w http.ResponseWriter, r *http.Request) {
    // Output to handler
    fmt.Fprintf(w, health())

    // log output
    outputLog("Served /health")
}
