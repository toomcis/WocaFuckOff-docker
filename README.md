# Wocabee Bot Docker ! NOT YET WORKING !

![logo](assets/logo.png)

**Project Overview**

- **Purpose:** Dockerized version of the Wocabee Bot for easy deployment without manual Chromium setup.
- **Main components:** Docker image with Chromium, VNC server, and the bot automation script.
- **Primary language focus:** Slovak (designed for Slovak → English), but the approach is language-agnostic in principle.

**Quick Notes**

- **AI-assisted:** This project was created with AI help and may contain bugs or imperfect heuristics. Don't be scared of making an [issue](https://github.com/toomcis/WocaFuckOff/issues) and reporting any bugs or imperfections!
- **VNC enabled:** Access the running container's desktop via VNC on port 5900 for visual monitoring.

**Requirements**

- **Docker & Docker Compose:** Ensure both are installed on your system.
- **Docker image:** Build locally or pull from registry.

**Configuration**

Configure the bot via environment variables in `docker-compose.yml`:

```yaml
environment:
  BOT_DEBUG: "true"
  NTFY_SERVER: "https://ntfy.sh"
  NTFY_TOPIC: "wocabee-bot"
  NTFY_TOKEN: ""
  TARGET_URL: "https://wocabee.app/"
  WORDLIST_FILE: "/bot/wordlist.json"
  PICTURE_FILE: "/bot/picturelist.json"
  PLACEHOLDER_WORDS: "translate,check"
```

Alternatively, edit the Dockerfile's `ENV` section directly.

**Usage**

**Build & Run with Docker Compose**

```bash
# Navigate to the docker directory
cd WocaFuckOff-docker

# Start the container
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the container
docker-compose down
```

**Build Manually**

```bash
# Build the image
docker build -t wocabee-bot .

# Run with environment variables
docker run -d \
  -e NTFY_TOPIC=wocabee-bot \
  -e TARGET_URL=https://wocabee.app/ \
  -p 5900:5900 \
  -p 9222:9222 \
  wocabee-bot
```

**Access via VNC**

Once the container is running, connect to the VNC server:

```bash
# Using vncviewer (Linux/macOS)
vncviewer localhost:5900

# Or use any VNC client and connect to localhost:5900
```

No password is required by default.

**Ports**

- **5900** — VNC server (visual desktop access)
- **9222** — Chromium remote debugging port (CDP)

**How it works**

- The Docker image starts an X server (Xvfb) for headless display.
- Chromium runs with remote debugging enabled on port 9222.
- The Wocabee Bot connects to Chromium via CDP and automates the learning tasks.
- VNC server allows you to monitor the bot's activity in real-time.

**Volumes & Persistence**

To persist word/picture mappings between runs, mount a volume:

```yaml
volumes:
  - ./data:/bot/data
```

Then adjust `WORDLIST_FILE` and `PICTURE_FILE` to point to `/bot/data/wordlist.json` and `/bot/data/picturelist.json`.

**Environment Variables Reference**

| Variable              | Default                   | Description                       |
| --------------------- | ------------------------- | --------------------------------- |
| `BOT_DEBUG`         | `true`                  | Enable debug output               |
| `NTFY_SERVER`       | (empty)                   | Ntfy server URL for notifications |
| `NTFY_TOPIC`        | (empty)                   | Ntfy topic for notifications      |
| `NTFY_TOKEN`        | (empty)                   | Ntfy authentication token         |
| `TARGET_URL`        | `https://wocabee.app/`  | Target site URL                   |
| `WORDLIST_FILE`     | `/bot/wordlist.json`    | Path to word mappings             |
| `PICTURE_FILE`      | `/bot/picturelist.json` | Path to picture mappings          |
| `PLACEHOLDER_WORDS` | `translate,check`       | Words to skip                     |
| `DISPLAY`           | `:99`                   | X display number                  |

**Troubleshooting**

- **Container won't start:** Check Docker logs with `docker-compose logs`.
- **VNC connection refused:** Ensure port 5900 is not blocked and the container is running.
- **Bot not connecting to site:** Verify `TARGET_URL` and `NTFY_SERVER`/`NTFY_TOPIC` settings.
- **Slow performance:** Adjust Xvfb screen resolution in the Dockerfile's startup command.

**Extending**

- Modify `DockerFile` to add dependencies or customize the environment.
- Override environment variables in `docker-compose.yml` for different deployments.
- Mount additional volumes for custom wordlists or configuration files.

**License & Attribution**

- This project uses the [MIT license](../LICENSE)
