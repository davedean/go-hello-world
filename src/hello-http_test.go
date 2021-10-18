package main

import "testing"

func TestHello(t *testing.T) {
    // Test the 'Hello' function
    got := Hello("World")
    want := "Hello, World"

    if got != want {
        t.Errorf("got %q want %q", got, want)
    }
}

func TestHealth(t *testing.T) {
    // Test the 'Health' function
    got := Health()
    want := "OK - 200 - Unknown"

    if got != want {
        t.Errorf("got %q want %q", got, want)
    }
}
