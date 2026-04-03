# Base Image
FROM ubuntu:24.04

# Install Dependencies
RUN apt-get update -o Acquire::ForceIPv4=true && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    wget \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libasound2t64 \
    libpangocairo-1.0-0 \
    libpango-1.0-0 \
    libgtk-3-0 \
    libgstreamer1.0-0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-libav \
    libglib2.0-0 \
    libdrm2 \
    libx11-xcb1 \
    libxcb-dri3-0 \
    libxshmfence1 \
    libwayland-server0 \
    libopus0 \
    libwebp7 \
    libavif16 \
    libharfbuzz-icu0 \
    libenchant-2-2 \
    libsecret-1-0 \
    libhyphen0 \
    libgraphene-1.0-0 \
    libxslt1.1 \
    libevent-2.1-7 \
    flite \
    ffmpeg \
    libgtk-4-1 \
    libgstreamer-gl1.0-0 \
    libmanette-0.2-0 \
    libwoff1 \
    libgles2 \
    libgstreamer-plugins-bad1.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /bot

# Create venv
RUN python3 -m venv /opt/venv

# Add venv python to PATH
ENV PATH="/opt/venv/bin:$PATH"

ARG CACHE_BUST=1
RUN git clone https://github.com/toomcis/WocaFuckOff.git /bot

# Install Python deps & Playwright
RUN pip install --upgrade pip && \
    pip install -r /bot/requirements.txt && \
    python -m playwright install-deps && \
    python -m playwright install

# Environment variables
ENV TARGET_URL=
ENV WORDLIST_FILE=
ENV PICTURE_FILE=
ENV PLACEHOLDER_WORDS=
ENV USERNAME=
ENV PASSWORD=
ENV DOUBLE_POINTS=false
ENV ADDON_POINTS=5000
ENV MILESTONE_REMINDER=1000
ENV CLASS_INDEX=0
ENV PACKAGE_INDEX=0
ENV NTFY_SERVER=
ENV NTFY_TOPIC=
ENV NTFY_TOKEN=

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/opt/venv/bin/python", "/bot/startup.py"]