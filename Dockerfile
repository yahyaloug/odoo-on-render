FROM odoo:17.0

WORKDIR /usr/src/app
COPY entrypoint.sh /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
CMD ["odoo", "-c", "/etc/odoo/odoo.conf"]
