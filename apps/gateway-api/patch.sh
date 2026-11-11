kubectl patch certificate box -n nginx-gateway --type=merge -p '
{
  "spec": {
    "secretTemplate": {
      "annotations": {
        "reflector.v1.k8s.emberstack.com/reflection-allowed": "true",
        "reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces": "default",
        "reflector.v1.k8s.emberstack.com/reflection-auto-enabled": "true",
        "reflector.v1.k8s.emberstack.com/reflection-auto-namespaces": "default"
      }
    }
  }
}'
