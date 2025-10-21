#!/bin/bash
set -e

: "${DB_HOST:=localhost}"
: "${DB_PORT:=5432}"
: "${DB_USER:=odoo}"
: "${DB_PASSWORD:=odoo}"
: "${ADMIN_PASSWORD:=admin}"
: "${DB_NAME:=postgres}"
: "${PORT:=8069}"

cat > /etc/odoo/odoo.conf <<EOC
[options]
admin_passwd = ${ADMIN_PASSWORD}
db_host = ${DB_HOST}
db_port = ${DB_PORT}
db_user = ${DB_USER}
db_password = ${DB_PASSWORD}
addons_path = /usr/lib/python3/dist-packages/odoo/addons
data_dir = /var/lib/odoo
http_port = ${PORT}
proxy_mode = True
EOC

mkdir -p /var/lib/odoo

echo "=== Starting Odoo 18 ==="
exec odoo -c /etc/odoo/odoo.conf -d ${DB_NAME} -i base --without-demo=all
