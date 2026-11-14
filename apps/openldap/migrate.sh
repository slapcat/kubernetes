for i in 0 1 2; do
	microk8s.kubectl cp backup.ldif openldap-${i}:/tmp/
	microk8s.kubectl exec -it openldap-$i -- slapadd -n2 -F /bitnami/openldap/slapd.d/ -l /tmp/backup.ldif
done
