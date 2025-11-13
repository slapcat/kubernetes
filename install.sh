# namespaces
kubectl create ns guacamole

# repos
#helm repo add external-secrets https://charts.external-secrets.io
#helm repo add mariadb-operator https://helm.mariadb.com/mariadb-operator
helm repo add helm-openldap https://jp-gouin.github.io/helm-openldap/
helm repo add authentik https://charts.goauthentik.io
helm repo update

# snapshots
cd /tmp
git clone https://github.com/kubernetes-csi/external-snapshotter.git
cd external-snapshotter
kubectl kustomize client/config/crd | kubectl create -f -
kubectl -n kube-system kustomize /deploy/kubernetes/snapshot-controller | kubectl create -f -
kubectl kustomize deploy/kubernetes/csi-snapshotter | kubectl create -f -

# applications
#helm install external-secrets external-secrets/external-secrets -n eso --create-namespace
#helm install mariadb-operator-crds mariadb-operator/mariadb-operator-crds
#helm install mariadb-operator mariadb-operator/mariadb-operator
helm install openldap helm-openldap/openldap-stack-ha --values openldap/values.yaml
#helm install redis oci://registry-1.docker.io/bitnamicharts/redis-cluster --set "metrics.enabled=true,cluster.nodes=3,cluster.replicas=0"
export RELEASE=$(curl https://storage.googleapis.com/kubevirt-prow/release/kubevirt/kubevirt/stable.txt)
kubectl apply -f https://github.com/kubevirt/kubevirt/releases/download/${RELEASE}/kubevirt-operator.yaml
kubectl apply -f https://github.com/kubevirt/kubevirt/releases/download/${RELEASE}/kubevirt-cr.yaml
export TAG=$(curl -s -w %{redirect_url} https://github.com/kubevirt/containerized-data-importer/releases/latest)
export VERSION=$(echo ${TAG##*/})
kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-operator.yaml
kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-cr.yaml
kubectl apply -f https://raw.githubusercontent.com/kubevirt-manager/kubevirt-manager/main/kubernetes/bundled.yaml
helm install -n authentik authentik authentik/authentik -f authentik/values.yaml --create-namespace
