#!/bin/bash

# update repo
# git clone https://github.com/rook/rook.git
cd rook
git pull
cd -

# create env variables
python3 ./rook/deploy/examples/create-external-cluster-resources.py --rbd-data-pool-name rbd --cephfs-filesystem-name nabasny --namespace rook-ceph --format bash > .env

# export env
. .env
export clusterNamespace=rook-ceph
export operatorNamespace=rook-ceph
export MANIFESTS='rook/deploy/examples/'

# create k8s resources
k create -f ${MANIFESTS}/common.yaml
k create -f ${MANIFESTS}/crds.yaml
k create -f ${MANIFESTS}/operator.yaml
k create -f ${MANIFESTS}/external/common-external.yaml
k create -f ${MANIFESTS}/external/cluster-external.yaml

# set a default SC
k patch storageclass cephfs -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# configure external cluster and check health
. ${MANIFESTS}/external/import-external-cluster.sh
sleep 30
k  -n rook-ceph  get CephCluster


