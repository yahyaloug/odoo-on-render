#!/bin/bash
set -e

# Create necessary directories
mkdir -p /var/lib/odoo/odoo-data/filestore
mkdir -p /var/lib/odoo/odoo-data/sessions
mkdir -p /etc/odoo
chmod -R 755 /var/lib/odoo/odoo-data

ODOO_CONF="/etc/odoo/odoo.conf"

# Check if we should use a specific database or allow selection
if [ -n "$DB_NAME" ] && [ "$DB_NAME" != "False" ]; then
  # Use specific database and initialize if needed
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
limit_memory_hard = 2684354560
limit_memory_soft = 2147483648
EOC

  echo "Using database: ${DB_NAME}"
  
  # Check if database needs initialization
  if ! psql "postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}" -c "SELECT 1 FROM information_schema.tables WHERE table_name='ir_module_module' LIMIT 1;" 2>/dev/null | grep -q 1; then
    echo "Initializing database ${DB_NAME}..."
    odoo -c $ODOO_CONF -i base --without-demo=all --stop-after-init
  fi
else
  # Allow database selection
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
workers = 0
EOC
fi

echo "Starting Odoo on port ${PORT:-8069}..."
exec odoo -c $ODOO_CONF
