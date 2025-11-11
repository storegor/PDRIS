#!/bin/bash

echo "??? Checking Minikube status..."
if ! minikube status &> /dev/null; then
    echo "!!! Minikube is not running. Starting it now... (this may take a few minutes)"
    minikube start
    if [ $? -ne 0 ]; then
        echo "ХХХ Failed to start Minikube. Aborting."
        exit 1
    fi

    echo "!!! Waiting for cluster storage to be ready..."
    kubectl wait --for=condition=available deployment/storage-provisioner -n kube-system --timeout=180s
else
    echo "[OK] Minikube is already running."
fi

cleanup() {
    echo -e "\n Stopping port-forward and deleting all Kubernetes resources..."
    if [[ -n $PORT_FORWARD_PID ]]; then
        kill $PORT_FORWARD_PID
        wait $PORT_FORWARD_PID 2>/dev/null
    fi
    ./delete.sh
    echo "Cleanup complete."
}

trap cleanup SIGINT SIGTERM


echo "Deploying application to Kubernetes..."
./apply.sh


echo "Waiting for all deployments to be ready..."
kubectl wait --for=condition=available deployment --all -n storegor-ns --timeout=180s


./port-forward.sh &
PORT_FORWARD_PID=$!

echo "Application is ready!"
echo "Forwarding port 8000 to localhost. Access at http://localhost:8000"
echo "Press [Enter] to stop the application and clean up all resources."
read

cleanup
