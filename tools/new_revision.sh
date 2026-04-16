#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BOARDS_DIR="$ROOT_DIR/boards"
TEMPLATE_DIR="$ROOT_DIR/templates/scratch-board"

usage() {
  cat <<'USAGE'
Usage:
  ./tools/new_revision.sh <new_revision> --from <existing_revision>
  ./tools/new_revision.sh <new_revision> --scratch

Examples:
  ./tools/new_revision.sh r3 --from r2.1
  ./tools/new_revision.sh r4 --scratch
USAGE
}

if [[ $# -lt 2 ]]; then
  usage
  exit 1
fi

NEW_REVISION="$1"
MODE="$2"
SOURCE_REVISION="${3:-}"
TARGET_DIR="$BOARDS_DIR/$NEW_REVISION"

if [[ -e "$TARGET_DIR" ]]; then
  echo "Error: $TARGET_DIR already exists."
  exit 1
fi

case "$MODE" in
  --from)
    if [[ -z "$SOURCE_REVISION" ]]; then
      echo "Error: --from requires a source revision."
      usage
      exit 1
    fi

    SOURCE_DIR="$BOARDS_DIR/$SOURCE_REVISION"
    if [[ ! -d "$SOURCE_DIR" ]]; then
      echo "Error: source revision not found: $SOURCE_DIR"
      exit 1
    fi

    mkdir -p "$TARGET_DIR"
    rsync -a --exclude='.git' --exclude='.DS_Store' "$SOURCE_DIR/" "$TARGET_DIR/"
    ;;
  --scratch)
    if [[ ! -d "$TEMPLATE_DIR" ]]; then
      echo "Error: scratch template not found: $TEMPLATE_DIR"
      exit 1
    fi

    mkdir -p "$TARGET_DIR"
    rsync -a --exclude='.DS_Store' "$TEMPLATE_DIR/" "$TARGET_DIR/"
    ;;
  *)
    echo "Error: unknown mode: $MODE"
    usage
    exit 1
    ;;
esac

cat > "$TARGET_DIR/REVISION.md" <<REVINFO
# $NEW_REVISION

Created: $(date +"%Y-%m-%d")
Mode: $MODE ${SOURCE_REVISION:+$SOURCE_REVISION}
REVINFO

echo "Created new revision at: $TARGET_DIR"
