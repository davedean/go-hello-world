#!/usr/bin/bash

# move to script location so docker commands have correct files
cd "$(dirname "$0")"/..

# build & tag
# we tag with localhost:5000 so we can push to minikube's registry
docker build . -t localhost:5000/go-hello-world -t go-hello-world 

# push
docker push localhost:5000/go-hello-world
