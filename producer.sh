#!/bin/bash

INPUT_FILE="deal_ids.txt"
PARALLEL_JOBS=8
TMPFS_SIZE=512M
TMP_DIR="./tmp"

# 실행 ID 및 로그/이미지 디렉토리
RUN_ID=$(date +%Y%m%d_%H%M%S)
IMG_DIR="./images/$RUN_ID"
LOG_DIR="./logs/$RUN_ID"

# tmpfs 마운트
sudo umount "$TMP_DIR" 2>/dev/null
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
sudo mount -t tmpfs -o size=$TMPFS_SIZE tmpfs "$TMP_DIR"

mkdir -p "$IMG_DIR" "$LOG_DIR"

START_TIME=$(date +%s)

# 병렬 실행
cat "$INPUT_FILE" | parallel -j "$PARALLEL_JOBS" ./consumer.sh {} "$TMP_DIR" "$LOG_DIR"

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# 이미지 이동
mv "$TMP_DIR"/* "$IMG_DIR"/ 2>/dev/null

# tmpfs 정리
sudo umount "$TMP_DIR"
rm -rf "$TMP_DIR"

echo "총 실행 시간: $DURATION초 ($(date))" | tee -a "$LOG_DIR/summary.log"
