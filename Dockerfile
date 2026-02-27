# Base Image
FROM ubuntu:24.04

# Install Dependencies
RUN apt-get update && apt-get install -y \
    chromium \
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

# Python Dependencies
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN git clone https://github.com/toomcis/WocaFuckOff.git /bot && \
    pip install -r /bot/requirements.txt && \
    playwright install chromium

# Set Working Directory
WORKDIR /bot

# Environment Variables
ENV DISPLAY=:99
ENV TARGET_URL=
ENV WORDLIST_FILE=
ENV PICTURE_FILE=
ENV PLACEHOLDER_WORDS=
ENV NTFY_SERVER=
ENV NTFY_TOPIC=
ENV NTFY_TOKEN=

# Expose Ports
EXPOSE 5900

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# CMD: start X server, fluxbox, VNC, then run Playwright via xvfb-run
CMD bash -c "\
    Xvfb :99 -screen 0 1920x1080x24 & \
    fluxbox & \
    x11vnc -display :99 -forever -nopw & \
    sleep 3 && \
    xvfb-run -a python3 /bot/solver.py"