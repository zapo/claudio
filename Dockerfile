FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends extrepo
RUN extrepo enable mise

# 1. Install system prerequisites
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ca-certificates procps openssh-client \
    mise \
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
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /workspace \
             /home/ubuntu/.config \
             /home/ubuntu/.claude && \
    chown -R ubuntu:ubuntu /workspace /home/ubuntu

# 3. Switch to user space
USER ubuntu
WORKDIR /workspace


RUN echo 'eval "$(mise activate bash)"' >> ~/.bashrc

RUN mise use -g node@22 && mise use -g npm:playwright
RUN mise exec -- npx playwright install chromium

RUN mise install go@latest && mise use -g go@latest
RUN mise install gh@latest && mise use -g gh@latest

RUN curl -fsSL https://claude.ai/install.sh | bash

CMD ["/home/ubuntu/.local/bin/claude", "agents"]
