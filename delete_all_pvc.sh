#!/bin/bash
APP="$1"
for i in `microk8s.kubectl get pvc | awk '{print $1}' | grep $APP`; do microk8s.kubectl delete pvc $i; done
