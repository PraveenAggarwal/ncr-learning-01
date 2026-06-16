FROM ubuntu:22.04

# Add Google Chrome repository
RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
    && apt-get update

# Install Chrome, X11, D-Bus, PulseAudio, and utilities
RUN apt-get install -y \
    google-chrome-stable \
    x11-utils \
    dbus \
    dbus-x11 \
    libpulse0 \
    pulseaudio \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create chrome user
RUN useradd -m -s /bin/bash chrome

# Setup X11 and XDG runtime directories
RUN mkdir -p /tmp/.X11-unix /tmp/xdg_runtime && \
    chmod 1777 /tmp/.X11-unix && \
    chmod 1777 /tmp/xdg_runtime

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default environment variables
ENV CHROME_URL="http://example.com"
ENV DISPLAY=":0.0"
ENV XDG_RUNTIME_DIR="/tmp/xdg_runtime"
ENV DBUS_SESSION_BUS_ADDRESS="unix:path=/run/dbus/system_bus_socket"
ENV PULSE_SERVER="/tmp/xdg_runtime/pa.socket"

# No exposed ports — rendering to X11 display
ENTRYPOINT ["/entrypoint.sh"]
