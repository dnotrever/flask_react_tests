FROM node:22-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip sqlite3 \
    git openssh-client bash build-essential ca-certificates sudo \
    && rm -rf /var/lib/apt/lists/*

ARG UID=1000
ARG GID=1000

RUN existing_user=$(getent passwd ${UID} | cut -d: -f1) && \
    if [ -n "$existing_user" ]; then \
        usermod -l appuser -d /home/appuser -m "$existing_user" 2>/dev/null || true; \
        groupmod -n appuser $(getent group ${GID} | cut -d: -f1) 2>/dev/null || true; \
    else \
        groupadd -g ${GID} appuser 2>/dev/null || true; \
        useradd -m -u ${UID} -g ${GID} -s /bin/bash appuser; \
    fi && \
    echo "appuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /app

COPY backend/requirements.txt /app/backend/requirements.txt
RUN pip install --break-system-packages --no-cache-dir -r /app/backend/requirements.txt

COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY . /app
RUN chown -R appuser:appuser /app && \
    chmod +x /app/scripts/*.sh

USER appuser

ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]

CMD []
