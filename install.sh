kubectl create ns authentik
helm repo add mariadb-operator https://helm.mariadb.com/mariadb-operator
helm repo add authentik https://charts.goauthentik.io
helm repo update
helm install mariadb-operator-crds mariadb-operator/mariadb-operator-crds
helm install mariadb-operator mariadb-operator/mariadb-operator
helm install openldap helm-openldap/openldap-stack-ha --values openldap/values.yaml
helm install redis oci://registry-1.docker.io/bitnamicharts/redis-cluster --set "metrics.enabled=true,cluster.nodes=3,cluster.replicas=0"
helm install -n authentik authentik authentik/authentik -f authentik/values.yaml
