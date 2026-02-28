# Base Image
FROM ubuntu:24.04

# Install Dependencies
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    fluxbox \
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    wget \
    libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 \
    libxcomposite1 libxdamage1 libxrandr2 libgbm1 libasound2t64 \
    libpangocairo-1.0-0 libpango-1.0-0 libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /bot

ENV PATH="/opt/venv/bin:$PATH"

RUN python3 -m venv /opt/venv && \
    git clone https://github.com/toomcis/WocaFuckOff.git . && \
    pip install -r requirements.txt && \
    playwright install chromium

# Environment Variables
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

# Expose Ports
EXPOSE 5900

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# CMD: start X server, fluxbox, VNC, and Chromium; run Playwright directly
CMD bash -c "\
    Xvfb :99 -screen 0 1920x1080x24 & \
    fluxbox & \
    x11vnc -display :99 -forever -nopw & \
    sleep 3 && \
    chromium --no-sandbox --remote-debugging-port=9222 & \
    python3 /bot/startup.py"