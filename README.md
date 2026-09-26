# db

模組三沙箱應用的資料庫。使用 Red Hat 的 `registry.redhat.io/rhel9/postgresql-16` image（不需自建 image），資料放在 PVC，`init.sql` 部署後匯入一次。

## 部署

```bash
oc apply -f pvc.yml
oc apply -f statefulset.yml
oc apply -f service.yml
oc get pod -w                                        # 等 postgresql-0 Running
oc exec -i postgresql-0 -- psql -U accounts < init.sql
oc exec postgresql-0 -- psql -U accounts -c 'select * from accounts'
```

## 重點

- image 讀取 `POSTGRESQL_USER`／`POSTGRESQL_PASSWORD`／`POSTGRESQL_DATABASE`，第一次啟動時自動建立使用者與資料庫（`postgres` 為保留帳號，不能拿來當 `POSTGRESQL_USER`）。
- 資料目錄是 `/var/lib/pgsql/data`（掛 PVC）。
- 此 image 支援 OCP 隨機非 root UID，不需要放寬 SCC。
- 這個 image 的 `postgresql-init/` 機制只接受 `*.sh`，而且執行時資料庫尚未建立，所以 `init.sql` 用 `oc exec … psql` 匯入。
- `init.sql` 只能匯入一次（INSERT 會重複）；資料在 PVC 上，Pod 重建不需要再匯入。
- API 連線設定：`DB_HOST=postgresql`、`DB_USER=accounts`、`DB_PASSWORD=accounts-pw`、`DB_NAME=accounts`。
- `registry.redhat.io` 需要 pull secret；OCP 叢集預設的全域 pull secret 已包含。

## 對應原廠主題

主題 10（儲存 PV/PVC/StorageClass）——資料庫掛載 PVC，示範刪除 Pod 後資料透過 PV 保留。
