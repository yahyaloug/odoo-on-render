#!/bin/bash
set -e

# ===============================
# Environment variables with defaults
# ===============================
: "${DB_HOST:=dpg-d3rn17emcj7s73cpnfo0-a.oregon-postgres.render.com}"
: "${DB_PORT:=5432}"
: "${DB_USER:=odoo_db_v18_user}"
: "${DB_PASSWORD:=1Xm4omYi5xff1L0q5m58JU8aNKYwKYl9}"
: "${ADMIN_PASSWORD:=admin}"
: "${DB_NAME:=odoo_db_v18}"
: "${PORT:=8069}"

echo "=== Database Connection Info ==="
echo "DB_HOST: ${DB_HOST}"
echo "DB_PORT: ${DB_PORT}"
echo "DB_USER: ${DB_USER}"
echo "DB_NAME: ${DB_NAME}"
echo "================================"

# ===============================
# Use HOME for writable files
# ===============================
mkdir -p $HOME/odoo-data
mkdir -p $HOME/addons

cat > $HOME/odoo.conf <<EOC
[options]
admin_passwd = ${ADMIN_PASSWORD}
db_host = ${DB_HOST}
db_port = ${DB_PORT}
db_user = ${DB_USER}
db_password = ${DB_PASSWORD}
db_name = ${DB_NAME}
addons_path = $HOME/addons
data_dir = $HOME/odoo-data
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

# ===============================
# Start Odoo
# ===============================
echo "=== Starting Odoo ==="
odoo -c $HOME/odoo.conf
