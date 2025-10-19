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
EOC

mkdir -p /var/lib/odoo
echo "=== Odoo Configuration ==="
cat /etc/odoo/odoo.conf
echo "=========================="

# Check if database is initialized
echo "=== Checking if database needs initialization ==="
if ! psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" -c "SELECT 1 FROM ir_module_module LIMIT 1" 2>/dev/null; then
    echo "Database not initialized. Installing base module..."
    odoo -c /etc/odoo/odoo.conf -i base --stop-after-init
    echo "Base module installed successfully!"
fi

echo "=== Starting Odoo ==="
exec "$@"
