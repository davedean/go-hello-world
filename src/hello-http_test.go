package main

import "testing"

func TestHello(t *testing.T) {
    got := Hello()
    want := "Hello, World"

    if got != want {
        t.Errorf("got %q want %q", got, want)
    }
}

func TestHealth(t *testing.T) {
    got := Health()
    want := "OK - 200"

    if got != want {
        t.Errorf("got %q want %q", got, want)
    }
}
