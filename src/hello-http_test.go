package main

import "testing"

func TestHello(t *testing.T) {
    // Test the 'Hello' function
    got := hello("World")
    want := "Hello, World"

    if got != want {
        t.Errorf("got %q want %q", got, want)
    }
}

func TestSetEnvironment(t *testing.T) {
    got := setEnvironment("DEV", true)
    want := "Development"

    if got != want {
        t.Errorf("got %q want %q", got, want)
    }
}

func TestHealth(t *testing.T) {
    // Test the 'Health' function
    got := health()
    want := "OK - 200 - Undefined"

    if got != want {
        t.Errorf("got %q want %q", got, want)
    }
}
