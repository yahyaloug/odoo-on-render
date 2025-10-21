#!/bin/bash
set -e

# Use environment variables
ODOO_CONF="/var/lib/odoo/odoo.conf"

# Generate configuration file
cat > $ODOO_CONF <<EOC
[options]
admin_passwd = ${ADMIN_PASSWORD}
db_host = ${DB_HOST}
db_port = ${DB_PORT}
db_user = ${DB_USER}
db_password = ${DB_PASSWORD}
db_name = ${DB_NAME}
addons_path = /usr/lib/python3/dist-packages/odoo/addons
data_dir = /var/lib/odoo/odoo-data
list_db = False
proxy_mode = True
http_port = ${PORT}
EOC

# Start Odoo with base module installation (force init)
odoo -c $ODOO_CONF -i base --load-language=en_US
