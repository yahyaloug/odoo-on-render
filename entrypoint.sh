#!/bin/bash
set -e

# ===============================
# Environment variables
# ===============================
: "${DB_HOST:=dpg-d3rn17emcj7s73cpnfo0-a.oregon-postgres.render.com}"
: "${DB_PORT:=5432}"
: "${DB_USER:=odoo_db_v18_user}"
: "${DB_PASSWORD:=1Xm4omYi5xff1L0q5m58JU8aNKYwKYl9}"
: "${DB_NAME:=odoo_db_v18}"
: "${ADMIN_PASSWORD:=admin}"
: "${PORT:=8069}"

# ===============================
# Create Odoo config
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

# ===============================
# Initialize database if empty
# ===============================
echo "=== Checking if database is initialized ==="
if ! PGPASSWORD=${DB_PASSWORD} psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c '\dt' | grep -q "res_users"; then
    echo "Database empty or not initialized. Installing base module..."
    odoo -c /etc/odoo/odoo.conf -i base --stop-after-init
else
    echo "Database already initialized."
fi

# ===============================
# Start Odoo server
# ===============================
echo "=== Starting Odoo ==="
exec odoo -c /etc/odoo/odoo.conf
