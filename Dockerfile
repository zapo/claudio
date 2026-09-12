FROM ubuntu:24.04

ARG MISE_ENV=""
ENV MISE_ENV=$MISE_ENV

RUN apt-get update && apt-get install -y --no-install-recommends extrepo
RUN extrepo enable mise

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ca-certificates procps openssh-client \
    mise \
    docker.io \
    docker-compose-v2 \
    && rm -rf /var/lib/apt/lists/*

RUN if [ "$MISE_ENV" = "playwright" ]; then \
    apt-get update && apt-get install -y --no-install-recommends \
    libasound2t64 \
    libatk1.0-0 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnss3 \
    libpango-1.0-0 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxdg-basedir1 \
    libxext6 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    fonts-liberation \
    fonts-noto-color-emoji \
    fonts-unifont \
    && rm -rf /var/lib/apt/lists/*; \
    fi

RUN mkdir -p /workspace \
             /home/ubuntu/.config \
             /home/ubuntu/.claude && \
    chown -R ubuntu:ubuntu /workspace /home/ubuntu

USER ubuntu
WORKDIR /workspace


COPY mise.toml mise.*.toml ./
RUN echo 'eval "$(mise activate bash)"' >> ~/.bashrc
RUN mise install
RUN if [ "$MISE_ENV" = "playwright" ]; then mise exec -- npx playwright install chromium; fi

ENTRYPOINT ["mise", "exec", "claude", "--", "claude"]
