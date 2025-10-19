#!/bin/bash
set -e

: "${DB_HOST:=localhost}"
: "${DB_PORT:=5432}"
: "${DB_USER:=odoo}"
: "${DB_PASSWORD:=odoo}"
: "${ADMIN_PASSWORD:=admin}"
: "${DB_NAME:=postgres}"

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
logfile = /var/log/odoo/odoo.log
EOC

mkdir -p /var/log/odoo
exec "$@"
