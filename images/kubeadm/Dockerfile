FROM weaveworks/ignite-ubuntu:latest
# Install dependencies. Use containerd for running the containers (for better performance)
RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-transport-https \
        containerd \
        curl \
        gnupg2 \
        jq \
    && apt-get clean

# Install k8s v1.15.0 locally
ENV KUBERNETES_VERSION=v1.15.0
COPY install.sh /
RUN /install.sh install release/stable-1.15 ${KUBERNETES_VERSION}
