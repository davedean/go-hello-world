# Simple hello world served over http

This is a simple hello world over http app in Golang. I built it for fun/interest sake, having not worked in Go before. The aim is to have a simple application I can use to deploy in other projects.

Features:

- external config of environment, via env var
- responds on /health with "OK - 200 - {ENVIRONMENT}"
- logs to stdout

- responds on / with "Hello, World"
- responds on /foo with "Hello, foo"
- returns on /favicon.ico with a png
- responds on another endpoint
