#!/bin/bash
set -e

# ===============================
# Default environment variables
# ===============================
: "${DB_HOST:=localhost}"
: "${DB_PORT:=5432}"
: "${DB_USER:=odoo}"
: "${DB_PASSWORD:=odoo}"
: "${DB_NAME:=postgres}"
: "${ADMIN_PASSWORD:=admin}"
: "${PORT:=8069}"

echo "=== Database Connection Info ==="
echo "DB_HOST: ${DB_HOST}"
echo "DB_PORT: ${DB_PORT}"
echo "DB_USER: ${DB_USER}"
echo "DB_NAME: ${DB_NAME}"
echo "================================"

# ===============================
# Generate Odoo config file
# ===============================
mkdir -p /var/lib/odoo
mkdir -p /etc/odoo

cat > /etc/odoo/odoo.conf <<EOC
[options]
admin_passwd = ${ADMIN_PASSWORD}
db_host = ${DB_HOST}
db_port = ${DB_PORT}
db_user = ${DB_USER}
db_password = ${DB_PASSWORD}
addons_path = /mnt/extra-addons
data_dir = /var/lib/odoo
list_db = True
proxy_mode = True
log_level = info
http_port = ${PORT}
dbfilter = .*
EOC

echo "=== Odoo Config ==="
cat /etc/odoo/odoo.conf
echo "==================="

# ===============================
# Start Odoo
# ===============================
echo "=== Starting Odoo 18 Server ==="
exec odoo -c /etc/odoo/odoo.conf
