#!/bin/bash

ID="$1"
TMP_DIR="$2"
LOG_DIR="$3"
URL="https://www.tmon.co.kr/deal/$ID"
FILENAME="deal_$ID.jpg"
OUTPUT_PATH="$TMP_DIR/$FILENAME"

START_TIME_MS=$(date +%s%3N)
START_TIME_FMT=$(date '+%Y-%m-%d %H:%M:%S')

wkhtmltoimage \
  --load-error-handling ignore \
  --disable-javascript \
  --width 860 \
  --height 700 \
  --quality 100 \
  "$URL" "$OUTPUT_PATH"

EXIT_CODE=$?
END_TIME_MS=$(date +%s%3N)
END_TIME_FMT=$(date '+%Y-%m-%d %H:%M:%S')
DURATION_MS=$((END_TIME_MS - START_TIME_MS))

if [ "$EXIT_CODE" -eq 0 ]; then
  echo "[$ID] $FILENAME | $DURATION_MS ms ($START_TIME_FMT → $END_TIME_FMT)" >> "$LOG_DIR/consumer.log"
else
  echo "[$ID] ERROR | $START_TIME_FMT → $END_TIME_FMT" >> "$LOG_DIR/error.log"
fi
