#!/usr/bin/env bash

SOURCE="$1"
TEXT="$2"
ICON_COUNT="$3"
shift 3

# Get volume (0.0–1.0) and muted state
VOLUME_RAW=$(wpctl get-volume "$SOURCE")

# Extract numeric value
VOLUME_FLOAT=$(echo "$VOLUME_RAW" | awk '{print $2}')
PERCENT=$(awk -v v="$VOLUME_FLOAT" 'BEGIN { printf("%d", v * 100) }')

# ---- INDEX CALCULATION ----
# index = floor(volume * (ICON_COUNT))
# You requested: volume * (length + 1)
# But that can overflow, so we clamp it.

INDEX=$(awk -v v="$VOLUME_FLOAT" -v n="$ICON_COUNT" \
    'BEGIN { i=int(v*(n)); if (i>=n) i=n-1; print i }')

ICON="$INDEX"
CLASS="active";
MUTED=$(echo "$VOLUME_RAW" | grep -q MUTED && echo 1 || echo 0)
if [ "$MUTED" -eq 1 ]; then
    ICON="muted";
    CLASS="muted";
fi

echo "{\"text\":\"$TEXT\",\"class\":\"$CLASS\",\"percent\":\"$VOLUME_FLOAT\", \"tooltip\":\"Microphone: $PERCENT%\",\"alt\":\"$ICON\"}"