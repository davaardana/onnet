#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="${ROOT_DIR}/backups"
CONTAINER_NAME="${DB_CONTAINER_NAME:-netpoint-postgres}"
DB_NAME="${DB_NAME:-netpoint_db}"
DB_USER="${DB_USER:-netpoint_user}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
OUTPUT_FILE="${BACKUP_DIR}/netpoint-${TIMESTAMP}.sql"

mkdir -p "${BACKUP_DIR}"

echo "Starting backup for ${DB_NAME} from container ${CONTAINER_NAME}..."
docker exec "${CONTAINER_NAME}" pg_dump -U "${DB_USER}" "${DB_NAME}" > "${OUTPUT_FILE}"

find "${BACKUP_DIR}" -type f -name 'netpoint-*.sql' -mtime +30 -delete

echo "Backup saved to ${OUTPUT_FILE}"
