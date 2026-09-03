#!/usr/bin/env bash
set -euo pipefail

ELASTIC_VERSION="8.15.3"
DEST_DIR="$(cd "$(dirname "$0")/.." && pwd)/files/elastic"

mkdir -p "$DEST_DIR"
cd "$DEST_DIR"

echo "Скачиваю Elastic Stack v${ELASTIC_VERSION} (нужен VPN, IP РФ заблокирован)..."

curl -fLO "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTIC_VERSION}-amd64.deb"
curl -fLO "https://artifacts.elastic.co/downloads/kibana/kibana-${ELASTIC_VERSION}-amd64.deb"
curl -fLO "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${ELASTIC_VERSION}-amd64.deb"

echo "Готово: ${DEST_DIR}"
ls -lh "${DEST_DIR}"