# Minikube deployment of go-hello-world

This was built on WSL2, which runs docker desktop "remotely" out from your Linux VM (in my case, Ubuntu). Also tested on MacOS (x86) to validate the instructions.

deployment.yml      - basic deployment of go-hello-world
service.yml         - basic service to access go-hello-world
build_minikube.sh   - a build script to build/tag/push go-hello-world to the minikube registry

## Setting up

Requires `minikube registry` to be installed for the build script to push to the registry.

Installing minikube registry: `minikube addons enable registry`

Additionally, some port forward is required:

```
# Set up a port forward from port 5000 to the minikube registry
kubectl port-forward --namespace kube-system service/registry 5000:80 &

# Set up a port forward from our localhost to the docker internal network
docker run -d --rm -it --network=host alpine ash -c "apk add socat && socat TCP-LISTEN:5000,reuseaddr,fork TCP:host.docker.internal:5000"
```

## Running

```
# create the deployment
kubectl apply -f deployment.yml

# create the service so you can access the deployment
kubectl apply -f service.yml
```

## Accessing your service via minikube

```
minikube service hello-world
```

Minikube will provide instructions.
