#!/bin/bash

VIDEO_DIR="$(xdg-user-dir DOCUMENTS)/recordings"

case "$1" in
    start)
        ## Kill any existing 'Recording_Mix' modules first
        #for mod in $(pactl list modules short | grep "recording_mix\|module-loopback" | cut -f1); do
        #    pactl unload-module "$mod" 2>/dev/null
        #done
        if ! pgrep -x "wf-recorder" > /dev/null; then
            mkdir -p "$VIDEO_DIR"

            # 1. Create the Virtual Sink
            pactl load-module module-null-sink \
                sink_name=recording_mix \
                sink_properties=device.description="Recording_Mix" \
                    > /tmp/wf_sink_id

            # 2. Identify Current Default Devices
            MIC=$(pactl get-default-source)
            SINK_MONITOR=$(pactl get-default-sink).monitor

            # 3. Loop both into the Virtual Sink
            # We save IDs to unload them later
            pactl load-module module-loopback \
                source="$MIC" sink=recording_mix > /tmp/wf_loop1
            pactl load-module module-loopback \
                source="$SINK_MONITOR" sink=recording_mix > /tmp/wf_loop2

            wf-recorder \
                --audio=recording_mix.monitor \
                -f "$VIDEO_DIR/recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4" &
        fi
        ;;
    stop)
        pkill -INT wf-recorder
		# Cleanup: Unload the virtual devices in reverse order
        [ -f /tmp/wf_loop1 ] && pactl unload-module $(cat /tmp/wf_loop1) && rm /tmp/wf_loop1
        [ -f /tmp/wf_loop2 ] && pactl unload-module $(cat /tmp/wf_loop2) && rm /tmp/wf_loop2
        [ -f /tmp/wf_sink_id ] && pactl unload-module $(cat /tmp/wf_sink_id) && rm /tmp/wf_sink_id
        ;;
    toggle)
        if pgrep -x "wf-recorder" > /dev/null; then
            $0 stop
        else
            $0 start
        fi
        ;;
    status)
        PID=$(pgrep -x "wf-recorder")
        if [ -n "$PID" ]; then
            # Calculate duration from process start time
            START_TIME=$(date -d "$(ps -o lstart= -p "$PID")" +%s)
            NOW=$(date +%s)
            SECONDS=$((NOW - START_TIME))
            TIME_STR=$(printf '%02d:%02d' $((SECONDS/60)) $((SECONDS%60)))

            echo "{\"text\": \" $TIME_STR\", \"alt\": \"recording\", \"class\": \"recording\"}"
        else
            echo "{\"text\": \"\", \"alt\": \"idle\", \"class\": \"idle\"}"
        fi
        ;;
esac
