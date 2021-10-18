# Minikube deployment of go-hello-world

This was built on WSL2, which runs docker desktop "remotely" out from your Linux VM (in my case, Ubuntu). 

Requires `minikube registry` to be installed for the build script to push to the registry.

deployment.yml      - basic deployment of go-hello-world
service.yml         - basic service to access go-hello-world
build_minikube.sh   - a build script to build/tag/push go-hello-world to the minikube registry
