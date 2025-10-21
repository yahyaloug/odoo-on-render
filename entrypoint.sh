#!/bin/bash
set -e

# Create necessary directories
mkdir -p /var/lib/odoo/odoo-data
mkdir -p /var/lib/odoo/sessions

# Set proper permissions
chown -R odoo:odoo /var/lib/odoo

# Use environment variables
ODOO_CONF="/etc/odoo/odoo.conf"

# Generate configuration file
cat > $ODOO_CONF <<EOC
[options]
admin_passwd = ${ADMIN_PASSWORD}
db_host = ${DB_HOST}
db_port = ${DB_PORT}
db_user = ${DB_USER}
db_password = ${DB_PASSWORD}
db_name = False
addons_path = /usr/lib/python3/dist-packages/odoo/addons
data_dir = /var/lib/odoo/odoo-data
list_db = True
proxy_mode = True
http_port = ${PORT:-8069}
workers = 2
max_cron_threads = 1
limit_time_cpu = 600
limit_time_real = 1200
EOC

# Set proper permissions for config
chown odoo:odoo $ODOO_CONF
chmod 640 $ODOO_CONF

echo "Starting Odoo on port ${PORT:-8069}..."

# Start Odoo as odoo user
exec gosu odoo odoo -c $ODOO_CONF
