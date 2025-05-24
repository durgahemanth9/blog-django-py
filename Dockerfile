FROM centos/python-35-centos7:latest

USER root

# Copy source code and scripts
COPY . /opt/app-root/src

# Move S2I scripts to correct path
RUN if [ -d /opt/app-root/src/.s2i/bin ]; then \
        mkdir -p /usr/libexec/s2i && \
        mv /opt/app-root/src/.s2i/bin/* /usr/libexec/s2i/; \
    fi && \
    rm -rf /opt/app-root/src/.git* && \
    chown -R 1001:0 /opt/app-root/src && \
    chmod -R g+w /opt/app-root/src /usr/libexec/s2i

USER 1001

# Set required environment variables
ENV S2I_SCRIPTS_PATH=/usr/libexec/s2i \
    S2I_BASH_ENV=/opt/app-root/etc/scl_enable \
    DISABLE_COLLECTSTATIC=1 \
    DISABLE_MIGRATE=1

# This line is NOT needed, S2I will run assemble automatically
# RUN /usr/libexec/s2i/assemble

# Final command (can be the default run script)
CMD ["/usr/libexec/s2i/run"]
