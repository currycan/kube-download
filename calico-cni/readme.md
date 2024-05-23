# 说明

## 安装

[Install using Helm](https://projectcalico.docs.tigera.io/getting-started/kubernetes/helm)

[Configuring calico/node | Calico Documentation](https://docs.tigera.io/calico/latest/reference/configure-calico-node#ip-autodetection-methods)


```bash
# helm show values projectcalico/tigera-operator --version v3.25.0
helm repo add projectcalico https://docs.projectcalico.org/charts
helm repo update
cat > values.yaml <<EOF
installation:
  enabled: true
  kubernetesProvider: ""
  calicoNetwork:
    ipPools:
    - blockSize: 26
      cidr: 172.30.0.0/16
      encapsulation: IPIP
      natOutgoing: Enabled
      nodeSelector: all()
    nodeAddressAutodetectionV4:
      interface: "eth.*|en.*"
EOF
# kubectl delete crd apiservers.operator.tigera.io
# kubectl delete ns tigera-operator

# kubectl create namespace tigera-operator,1.18支持 3.22.5
version=3.22.5
# version=3.21.6
# version=3.20.6
curl -o /usr/local/bin/calicoctl -O -L  "https://github.com/projectcalico/calicoctl/releases/download/v3.20.6/calicoctl"
chmod +x /usr/local/bin/calicoctl

helm upgrade --install calico projectcalico/tigera-operator \
  --create-namespace -n tigera-operator \
  -f values.yaml \
  --version v${version}
```
