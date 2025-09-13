#!/bin/bash
set -e
DEFAULT_FLAGS="--no-sandbox --disable-dev-shm-usage --start-maximized"
exec /usr/bin/chromium $DEFAULT_FLAGS $CHROME_FLAGS
