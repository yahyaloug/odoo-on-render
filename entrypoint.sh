#!/bin/bash
set -e

: "${DB_HOST:=localhost}"
: "${DB_PORT:=5432}"
: "${DB_USER:=odoo}"
: "${DB_PASSWORD:=odoo}"
: "${ADMIN_PASSWORD:=admin}"
: "${DB_NAME:=postgres}"
: "${PORT:=8069}"

echo "=== Database Connection Info ==="
echo "DB_HOST: ${DB_HOST}"
echo "DB_PORT: ${DB_PORT}"
echo "DB_USER: ${DB_USER}"
echo "DB_NAME: ${DB_NAME}"
echo "================================"

cat > /etc/odoo/odoo.conf <<EOC
[options]
admin_passwd = ${ADMIN_PASSWORD}
db_host = ${DB_HOST}
db_port = ${DB_PORT}
db_user = ${DB_USER}
db_password = ${DB_PASSWORD}
db_name = ${DB_NAME}
addons_path = /mnt/extra-addons
data_dir = /var/lib/odoo
logfile = False
log_level = info
http_port = ${PORT}
db_filter = ^${DB_NAME}$
list_db = False
proxy_mode = True
workers = 2
max_cron_threads = 1
limit_memory_hard = 2684354560
limit_memory_soft = 2147483648
limit_request = 8192
limit_time_cpu = 600
limit_time_real = 1200
EOC

mkdir -p /var/lib/odoo

echo "=== Odoo Configuration ==="
cat /etc/odoo/odoo.conf
echo "=========================="

echo "=== Starting Odoo ==="
exec odoo -c /etc/odoo/odoo.conf --load-language=en_US
