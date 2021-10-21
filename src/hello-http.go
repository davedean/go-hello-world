package main

import (
    "log"
    "fmt"
    "net/http"
    "time"
    "os"
    "encoding/base64"
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
    http.HandleFunc("/favicon.ico", handlerFavicon)

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

func handlerFavicon(w http.ResponseWriter, r *http.Request) {
    // server responding on favicon.ico without actually having one was annoying me

    // favicon in base64
    favicon := "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAFiUAABYlAUlSJPAAAAVnSURBVEhL7ZV/TFNXFMfPu32vP+kPoKWthaEQhooanUVUhmbg3NSIgIMpm24sTuccmdHg/tDFmGWJYcuWbHFuMzPqNn8BKjHG7Y8pCggR8SeKolOYYoFKsC2F9r3X93ZuW6duS/zLJUv85qa9593z7rnv3HM/l4FdPfA0RaL/T03PAjxR/00APhYkRdgECJjpr6iFQALtY5MBBAOElOFhgJAKhJhoHxVShz0t9Pcvn0dEcPbDuc5J+j4aI2AWimPBby0a9Y1counKTwkUGyFo3excUuo4Qd8PqbJsB2uyVkdjiLqM+GPyIuIqtMmlZHpsxz9jEJAVRs4DMqFLCylYlQ8ksKldmy5XJld3qfcPAgka2EEN4UFm0F9JgkbWj2/RV2C4bV4Rs1e21/QxVe7GBVNBiKVf/IhoioZDmsy4M05LU1pCc2RYkLgx+itjHQ3p5jMgs5JMsNEBwHESivRD6nnJO49eLQMmCNpe4M0N3Y5c6xmQ2LBjVNSVl1TzRxx4+7ndy0ftwOnwiSArnfENq1K+L7Qdf7g9fxexqd29QQswobAluoMJenYQAD/0oWiAGNa37uIXH7Rsqzj1LTAiPlGT4Z86l61q3LW5vRwUQXwiYGBJFVldCPMjKTFFV3xpTtMFWhG4CJ7Ns5w7PTA+Gu+BaACtYsiE28B5gQPaABSMONF4abTt1HRrHcgcmpNN5ycn1KcbO0SZpOhuZlgaZlpPNHUuG5f465spVQwJrc8qG/ZluoZMQCQ6xQMpoHBtABStA5l+mgqZyFDXn3NfUmeYzk2La8kxNx50FbmFGGdc85S4syOU/mrX7HTD5amxrdnxF2q652+6XL569OYNz2+57XPOqd8DKvfjGUILaSpqQBEAJrK/OuD8IHEQ0oQdAFhvODkq2mcEIAKEtOEBGTgfLScsWdx2LDOsrsdnRz3D9RNFwhVmiFqCHkR1tI+Awk3B5AbjwqixRIcoUdA0QxAdwuuLeEYk6qIE442RUaJU3W6YUUptQf/R+LUrRtbSiYLxv82aTCQTiKr62RMHiixiia5kRB26Ea6vt9DqKkhseTmPBRY9f8nLVMoGGkPUvZNW2VOQ2FtoP5KzCCQdSITwnknZKYcoFEXtytTvKlK3gxgDxJtrvib5VFfm23d0fBq7v5/d79uXW5CsHdBw/WIwxb7b9Vln3sWZxRBkp8VfpJFQEpcV31TeusO6r+/zzrnyYh0ELQQUYm3X+FftTcC5egfmJhgaQVTMTNpbfXM5qPxj9EM/XC+AmF4k0Ifn3l+Tun1I1PJ4nmXoF00+UY/T8tLDDCHEkAugvX/81vJ6d+JLttMsKIa3dS5dnHTIqxp16G7+WX5oqrW9xHFg6/VKxtAe8KUDG0VNT8A6xTAgS5qRCadcS0w2pcD87I+c/H8Ry7d5xzk0t/ELAke6lr7mqC6wH6nqXrDnzsLSpAP5lgvHel6Qhx1q4zUQkMwIIM1Y/dVrg6lE4e/sm27feb91UDcnsRHZjqJ0whY+ZhIWDoKLV84wn2zzTiDASCAkdEmeCkfLDY/15B9vlGds6PFNAQUPov2qR/3xhK0waI3RX9o4Yc8nHSv07JARqaWD/OadtVllIIKSgFnp0Ss9mEaklonzMZx3nXNlBms+fy8tXGect6JtY+WN94BD2Gq/+n3h+vY19Nyr3GMOuzMsNb7FhubsMlvVLWAGedH0Y/cc9Lx775WjXhso4cuOd6uzZ9W9uOCtpNrqO68XJ3/dmFMUI9mYmi7Q9D5ABeIIyxYphMIbmCAAedrHh2gimhDjSB4i0lRgHUc8sbgRwyI6hKuI3nR4MyLE8FqKoukZi56o/3sAgD8BtbhBUFo1/IYAAAAASUVORK5CYII"

    // decode the favicon from base64
    faviconDecode, err := base64.RawStdEncoding.DecodeString(favicon)

    if err == nil {
        // write bytes 
        w.Write(faviconDecode)
    } else {
        // log the failure, this should never happen.
        outputLog("decode failed")
        fmt.Println(err)
    }

    // log output
    outputLog("Served /favicon.ico")

}
