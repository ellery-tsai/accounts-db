# db

模組三沙箱應用的資料庫初始化腳本。**不需要自建 image**，直接部署 OCP 內建的標準 postgres image（例如 `postgres:16` 或 OCP catalog 內的 PostgreSQL template），把 `init.sql` 掛進去即可。

## 建議部署方式

```bash
oc create configmap accounts-db-init --from-file=init.sql
oc new-app postgresql-persistent \
  -p POSTGRESQL_USER=accounts \
  -p POSTGRESQL_PASSWORD=accounts \
  -p POSTGRESQL_DATABASE=accounts
```

若用官方 `postgres` image，可把 `init.sql` 掛載到 `/docker-entrypoint-initdb.d/`，容器首次啟動時會自動執行。若用 OCP catalog 的 PostgreSQL template，則需另外用一個 init Job 或手動執行 `psql` 匯入，依現場選用的 image 調整。

## 對應原廠主題

主題 10（儲存 PV/PVC/StorageClass）——資料庫需掛載 PVC，示範刪除 Pod 後資料透過 PV 保留。
