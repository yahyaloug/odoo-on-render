#!/bin/bash
set -e

# ===============================
# Environment variables
# ===============================
: "${DB_HOST:?Need to set DB_HOST}"
: "${DB_PORT:=5432}"
: "${DB_USER:?Need to set DB_USER}"
: "${DB_PASSWORD:?Need to set DB_PASSWORD}"
: "${ADMIN_PASSWORD:=admin}"
: "${DB_NAME:?Need to set DB_NAME}"
: "${PORT:=8069}"

echo "=== Database Connection Info ==="
echo "DB_HOST: ${DB_HOST}"
echo "DB_PORT: ${DB_PORT}"
echo "DB_USER: ${DB_USER}"
echo "DB_NAME: ${DB_NAME}"
echo "================================"

# ===============================
# Generate Odoo configuration
# ===============================
mkdir -p /etc/odoo
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
list_db = True
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

# ===============================
# Start Odoo
# ===============================
echo "=== Starting Odoo ==="
odoo -c /etc/odoo/odoo.conf
