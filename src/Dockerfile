FROM registry.fedoraproject.org/fedora:40

# Environment for Podman storage
ENV CONTAINERS_STORAGE_CONF=/etc/containers/storage.conf \
    STORAGE_RUNROOT=/run/containers/storage \
    STORAGE_GRAPHROOT=/var/lib/containers/storage \
    _CONTAINERS_USERNS_CONFIGURED=""

# Install runtime dependencies (Podman + Python)
RUN dnf install -y \
        podman \
        fuse-overlayfs \
        shadow-utils \
        python3 \
    && dnf clean all

# Allow unprivileged user namespaces
RUN chmod u+s /usr/bin/newuidmap /usr/bin/newgidmap

# Create podmanuser with UID/GID 1000 and storage dirs
RUN groupadd -g 1000 podmanuser \
 && useradd -u 1000 -g podmanuser -m -s /bin/bash podmanuser \
 && mkdir -p /run/containers/storage /var/lib/containers/storage /home/podmanuser/workspace \
 && chown -R podmanuser:podmanuser /run/containers/storage /var/lib/containers/storage /home/podmanuser/workspace 

# Copy in your host storage.conf
COPY storage.conf /etc/containers/storage.conf

# Create minimal health-check server script
COPY healthz.py /home/podmanuser/healthz.py
RUN chown podmanuser:podmanuser /home/podmanuser/healthz.py

# Switch to non-root user
USER podmanuser

# Expose port for Kubernetes probes
EXPOSE 8080

# Launch health-check server
CMD ["python3", "/home/podmanuser/healthz.py"]
