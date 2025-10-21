#!/bin/bash
set -e

# Create necessary directories if they don't exist
mkdir -p /var/lib/odoo/odoo-data
mkdir -p /var/lib/odoo/odoo-data/filestore
mkdir -p /var/lib/odoo/odoo-data/sessions
mkdir -p /etc/odoo

# Ensure proper permissions
chmod -R 755 /var/lib/odoo/odoo-data

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
db_name = ${DB_NAME}
addons_path = /usr/lib/python3/dist-packages/odoo/addons
data_dir = /var/lib/odoo/odoo-data
list_db = False
proxy_mode = True
http_port = ${PORT:-8069}
workers = 0
max_cron_threads = 0
limit_memory_hard = 2684354560
limit_memory_soft = 2147483648
limit_time_cpu = 600
limit_time_real = 1200
db_maxconn = 64
log_level = info
EOC

echo "Starting Odoo on port ${PORT:-8069}..."

# Start Odoo normally (will auto-initialize database)
exec odoo -c $ODOO_CONF
