# Base Image
FROM ubuntu:24.04

# Install Dependencies
RUN apt-get update && apt-get install -y \
    chromium-browser \
    xvfb \
    x11vnc \
    fluxbox \
    python3 \
    python3-pip \
    git \
    curl \
    wget \
    libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 \
    libxcomposite1 libxdamage1 libxrandr2 libgbm1 libasound2 \
    libpangocairo-1.0-0 libpango1.0-0 libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*

# Python Dependencies
RUN pip3 install --no-cache-dir playwright requests
RUN playwright install chromium

# Set Working Directory
WORKDIR /bot

# Copy or Clone Your Bot
COPY . /bot

# Environment Variables
ENV BOT_DEBUG=true
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
EXPOSE 9222

# Startup Command
CMD bash -c "\
    Xvfb :99 -screen 0 1920x1080x24 & \
    fluxbox & \
    x11vnc -display :99 -forever -nopw & \
    chromium --remote-debugging-port=9222 --user-data-dir=/bot/chrome-profile $TARGET_URL & \
    sleep 5 && \
    python3 /bot/wocabee_bot.py"