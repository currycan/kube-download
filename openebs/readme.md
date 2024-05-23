# 安装

## 参考

[charts/charts/openebs/README.md at main · openebs/charts](https://github.com/openebs/charts/blob/main/charts/openebs/README.md)
[openebs 1.11.0 · openebs/openebs](https://artifacthub.io/packages/helm/openebs/openebs/1.11.0)

## 部署

```bash
helm repo add openebs https://openebs.github.io/charts
helm repo update
helm upgrade --install openebs openebs/openebs --create-namespace -n openebs --reuse-values \
  --set jiva.enabled=true \
  --version 2.12.9 \
  --dry-run
```
