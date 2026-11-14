helm uninstall openldap; ../delete_all_pvc.sh openldap; helm install openldap helm-openldap/openldap-stack-ha --values values.yaml
