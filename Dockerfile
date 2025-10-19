FROM odoo:17.0

WORKDIR /usr/src/app
COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
# Add -i base to initialize the database on first run
CMD ["odoo", "-c", "/etc/odoo/odoo.conf", "-i", "base", "--stop-after-init"]
