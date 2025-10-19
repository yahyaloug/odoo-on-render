FROM odoo:17.0

# Debug: List files in build context
RUN echo "=== Build context root ===" && ls -la /

# Copy the file
COPY entrypoint.sh /entrypoint.sh

# Debug: Verify it was copied
RUN echo "=== After COPY ===" && ls -la / | grep entrypoint

# Make executable
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo", "-c", "/etc/odoo/odoo.conf"]
