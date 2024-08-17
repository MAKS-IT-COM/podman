FROM registry.fedoraproject.org/fedora:40

# Set environment variables for storage configuration
ENV CONTAINERS_STORAGE_CONF=/etc/containers/storage.conf \
    STORAGE_RUNROOT=/run/containers/storage \
    STORAGE_GRAPHROOT=/var/lib/containers/storage \
    _CONTAINERS_USERNS_CONFIGURED=""

# Install necessary packages
RUN dnf install -y podman fuse-overlayfs shadow-utils && \
    dnf clean all

# Set the setuid bit on newuidmap and newgidmap
RUN chmod u+s /usr/bin/newuidmap /usr/bin/newgidmap

# Create a non-root user and group with UID/GID 1000
RUN groupadd -g 1000 podmanuser && \
    useradd -u 1000 -g podmanuser -m -s /bin/bash podmanuser && \
    mkdir -p /run/containers/storage /var/lib/containers/storage && \
    chown -R podmanuser:podmanuser /run/containers/storage /var/lib/containers/storage

# Copy the storage.conf file from the host to the container
COPY storage.conf /etc/containers/storage.conf

# Switch to the non-root user
USER podmanuser

# Create a volume for persistent storage if needed
# VOLUME /home/podmanuser/.local/share/containers/storage

# Run an infinite sleep to keep the container running
CMD ["sleep", "infinity"]
