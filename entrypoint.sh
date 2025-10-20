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

echo "=== Odoo Configuration ==="
cat /etc/odoo/odoo.conf
echo "=========================="

# Create init script to set admin user
cat > /tmp/init_admin.py <<'PYTHON'
import odoo
from odoo import api, SUPERUSER_ID

def init_admin():
    with api.Environment.manage():
        registry = odoo.registry(odoo.tools.config['db_name'])
        with registry.cursor() as cr:
            env = api.Environment(cr, SUPERUSER_ID, {})
            # Check if admin user exists
            admin_user = env['res.users'].search([('login', '=', 'admin')], limit=1)
            if not admin_user:
                print("Creating admin user...")
                env['res.users'].create({
                    'name': 'Administrator',
                    'login': 'admin',
                    'password': 'admin',
                    'email': 'admin@example.com',
                })
                cr.commit()
                print("Admin user created: login=admin, password=admin")
            else:
                print("Admin user already exists")

if __name__ == '__main__':
    odoo.tools.config.parse_config(['-c', '/etc/odoo/odoo.conf'])
    init_admin()
PYTHON

echo "=== Starting Odoo ==="
# Start Odoo in background
odoo -c /etc/odoo/odoo.conf &
ODOO_PID=$!

# Wait for Odoo to start
sleep 10

# Create admin user
python3 /tmp/init_admin.py

# Keep Odoo running
wait $ODOO_PID
