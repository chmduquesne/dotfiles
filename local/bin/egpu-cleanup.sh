#!/bin/bash

# Configuration
PCI_ADDR="0000:68:00.0"
TAG="egpu-cleanup"
MODULES=("nvidia_uvm" "nvidia_drm" "nvidia_modeset" "nvidia")

# Function to log to systemd journal
log_msg() {
    # -t sets the tag, -p sets priority (notice, err, etc.)
    logger -t "$TAG" "$1"
}

log_msg "Starting cleanup for $PCI_ADDR"

# 1. Logical Disconnect
if [ -e "/sys/bus/pci/devices/$PCI_ADDR" ]; then
    log_msg "Device $PCI_ADDR found. Unbinding and removing..."

    if [ -e "/sys/bus/pci/devices/$PCI_ADDR/driver/unbind" ]; then
        echo "$PCI_ADDR" > "/sys/bus/pci/devices/$PCI_ADDR/driver/unbind" || log_msg "ERROR: Failed to unbind driver"
    fi

    echo 1 > "/sys/bus/pci/devices/$PCI_ADDR/remove" || log_msg "ERROR: Failed to remove device"
else
    log_msg "Device $PCI_ADDR not found on bus. Skipping PCI removal."
fi

# 2. Module Removal
for mod in "${MODULES[@]}"; do
    if lsmod | grep -q "$mod"; then
        log_msg "Attempting to unload $mod..."
        # Capture stderr and send it to logger if modprobe fails
        ERR_MSG=$(modprobe -r "$mod" 2>&1)
        if [ $? -ne 0 ]; then
            log_msg "WARNING: Could not unload $mod. Reason: $ERR_MSG"
        else
            log_msg "Successfully unloaded $mod"
        fi
    fi
done

log_msg "Cleanup sequence complete."
