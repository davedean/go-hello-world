# go-hello-world

A basic hello world app in Go so I have a simple "middleware" to use for deploying, and some deployment examples. 

## Middleware related:

* src               - http hello world
* Dockerfile        - runs http hello world
* .github/workflows - some simple CI Github Actions to build/test on PR and commits to main

## Deploy Examples:
* minikube          - a basic minikube deployment for local development
* fargate           - an AWS fargate deployment, using terraform [under development]
