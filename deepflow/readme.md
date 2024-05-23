
```bash
helm repo add deepflow https://deepflowio.github.io/deepflow
helm repo update deepflow # use `helm repo update` when helm < 3.7.0
helm install deepflow -n deepflow deepflow/deepflow --create-namespace

---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: deepflow-mysql-data-pvc
  namespace: deepflow
spec:
  storageClassName: nfs-storage-class
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 20Gi
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: clickhouse-path-deepflow-clickhouse-0
  namespace: deepflow
spec:
  storageClassName: nfs-storage-class
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: clickhouse-storage-path-deepflow-clickhouse-0
  namespace: deepflow
spec:
  storageClassName: nfs-storage-class
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi

helm upgrade --install deepflow -n deepflow  --create-namespace deepflow/deepflow
```
