# WocaFuckOff Docker

![logo](assets/logo.png)

**Project Overview**

* **Purpose:** Fully containerized deployment of the WocaFuckOff Wocabee automation bot with Playwright and bundled browser dependencies.
* **Main components:** Ubuntu-based Docker image, Python virtual environment, Playwright (Chromium), and the WocaFuckOff automation scripts.
* **Primary language focus:** Slovak → English by default, but fully configurable for other language pairs supported by the target platform.

**Quick Notes**

* **AI-assisted:** Parts of this project were created with AI assistance. If you encounter unexpected behavior, open an issue: [issue](https://github.com/toomcis/WocaFuckOff-docker/issues) ! NOTE: If you encounter an issue with the script itself, please make a bug report under the original [WocaFuckOff project here](https://github.com/toomcis/WocaFuckOff/issues) !
* **Playwright-powered:** Uses Playwright with an installed Chromium build inside the container.
* **Notification support:** Optional integration with ntfy for runtime and startup error notifications.

---

## Requirements

* **Docker**
* **Docker Compose** (recommended for easier configuration)
* A valid Wocabee account

---

## Usage

### Build & Run with Docker Compose

## Running without building

- This is the preferred way of using this docker image
- Be sure to setup the variables correctly, by default it will farm ~5000 points which might not be the desired setup, please change `ADDON_POINTS` enviromental variable if you want this to be different
- Another thing to watch out for it selecting the proper class and package using `CLASS_INDEX` and `PACKAGE_INDEX`
- Username and Password are required to work, otherwise it will just autoclose  

```yml
services:
  wocabee:
    build:
      context: .
      dockerfile: Dockerfile
      network: host
    image: ghcr.io/toomcis/wocafuckoff-docker:latest  # Image path
    container_name: wocafuckoff
    restart: "no"
    environment:
      - TARGET_URL=${TARGET_URL} # Targeting URL for bot to interact, dont change unless you know what you are doing
      - WORDLIST_FILE=${WORDLIST_FILE} # Path to wordlist file, doesn't need mounting, optional
      - PICTURE_FILE=${PICTURE_FILE} # Path to picture file, doesn't need mounting, optional
      - PLACEHOLDER_WORDS=${PLACEHOLDER_WORDS} # Comma separated list of placeholder words to ignore, optional
      - CLASS_INDEX=${CLASS_INDEX} # Class index to target, default is 0 for first class, optional
      - PACKAGE_INDEX=${PACKAGE_INDEX} # Package index to target, default is 0 for first package, optional
      - USERNAME=${USERNAME} # Username for login into Wocabee
      - PASSWORD=${PASSWORD} # Password for login into Wocabee
      - DOUBLE_POINTS=${DOUBLE_POINTS} # Set to true to enable double points mode, default is false for normal more, optional
      - ADDON_POINTS=${ADDON_POINTS} # Number of addon points to use, default is 5000
      - MILESTONE_REMINDER=${MILESTONE_REMINDER} # Number of points to trigger milestone reminder, default is 1000, optional
      - NTFY_SERVER=${NTFY_SERVER} # NTFY server URL for notifications, optional
      - NTFY_TOPIC=${NTFY_TOPIC} # NTFY topic for notifications, optional
      - NTFY_TOKEN=${NTFY_TOKEN} # NTFY token for authentication, optional
    tty: true
    stdin_open: true
    network_mode: "host"
```

- After that you can simply do `docker-compose up` and it will farm the points!

## Building manually

- If you wish to build this image manually, you can use the same docker-compose.yml file mentioned above, or just do

```bash
# Grab the repository
git clone https://github.com/toomcis/WocaFuckOff-docker.git

# Run container (Using the above compose file)
docker-compose up --build
```

---

## How It Works

* The container is based on **Ubuntu 24.04**.
* A Python virtual environment is created at `/opt/venv`.
* The WocaFuckOff repository is cloned into `/bot`.
* Playwright installs all required browser dependencies and a bundled Chromium build. (This is the reason the image is ~1.2GB in size)
* On startup, the container runs:

```bash
/opt/venv/bin/python /bot/startup.py
```

* The bot:

  * Creates a Chromium instance and connects playwright to it
  * Navigates to `TARGET_URL`.
  * Handles exercises automatically (translate, choose word, pexeso, complete word, picture tasks, etc.).
  * Updates word and picture mappings dynamically. (not actually tested, if you find it doesn't work, please report it in the [issues](https://github.com/toomcis/WocaFuckOff-docker/issues))
  * Sends ntfy notifications on runtime/startup errors (if configured).

---

## Environment Variables Reference

| Variable             | Default                   | Description                      | Optionable                                            |
| -------------------- | ------------------------- | -------------------------------- |-------------------------------------------------------|
| `TARGET_URL`         | `https://wocabee.app/app` | Target Wocabee URL               | ✅ ! Dont change unless you know what you are doing ! |
| `WORDLIST_FILE`      | `wordlist.json`           | JSON file storing word mappings  | ✅ ! Dont change unless you know what you are doing ! |
| `PICTURE_FILE`       | `picturelist.json`        | JSON file storing image mappings | ✅ ! Dont change unless you know what you are doing ! |
| `PLACEHOLDER_WORDS`  | `translate,check`         | Words to ignore                  | ✅ ! Dont change unless you know what you are doing ! |
| `USERNAME`           | (empty)                   | Login username                   | ❎                                                    |
| `PASSWORD`           | (empty)                   | Login password                   | ❎                                                    |
| `DOUBLE_POINTS`      | `false`                   | Enable double points mode        | ✅                                                    |
| `ADDON_POINTS`       | `5000`                    | Target addon points              | ✅                                                    |
| `MILESTONE_REMINDER` | `1000`                    | Reminder interval                | ✅                                                    |
| `CLASS_INDEX`        | `0`                       | Class selection index            | ✅                                                    |
| `PACKAGE_INDEX`      | `0`                       | Package selection index          | ✅                                                    |
| `NTFY_SERVER`        | (empty)                   | ntfy server URL                  | ✅                                                    |
| `NTFY_TOPIC`         | (empty)                   | ntfy topic                       | ✅                                                    |
| `NTFY_TOKEN`         | (empty)                   | ntfy auth token                  | ✅                                                    |

---

## Troubleshooting

* **Container exits immediately**

  * Check logs: `docker-compose logs`
  * Verify required environment variables.

* **Browser does not start**

  * Ensure Playwright installed correctly during build.
  * Rebuild the image with `--no-cache`.

* **Bot not attaching via CDP**

  * Make sure remote debugging is enabled on the external browser.
  * Otherwise the bot will launch its own instance automatically.

* **Mappings not saved**

  * Confirm volume mounting is configured correctly.
  * Ensure file paths match `WORDLIST_FILE` and `PICTURE_FILE`.

---

## License & Attribution

* Licensed under the [MIT license](../LICENSE)
