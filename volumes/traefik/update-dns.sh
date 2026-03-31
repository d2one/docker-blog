#!/usr/bin/env sh
# DNS challenge exec solver for Let's Encrypt via reg.ru API.
# Credentials are passed via environment variables REGRU_USERNAME and REGRU_PASSWORD.

set -e

# Extract domain and subdomain from FQDN (strip trailing dot if present)
FQDN=$(echo "$2" | sed 's/\.$//')
DOMAIN=$(echo "$FQDN" | sed 's/^[^.]*\.//')
SUBDOMAIN=$(echo "$FQDN" | sed "s/\.${DOMAIN}$//")

check_response() {
  RESPONSE="$1"
  ACTION="$2"
  if echo "$RESPONSE" | grep -q '"result" *: *"success"'; then
    echo "${ACTION}: OK"
  else
    echo "${ACTION}: FAILED - ${RESPONSE}" >&2
    exit 1
  fi
}

case "$1" in
  "present")
    echo "Present: subdomain=${SUBDOMAIN}.${DOMAIN}, value=$3"

    RESPONSE=$(wget -qO- \
      --header="Content-Type: application/x-www-form-urlencoded" \
      --post-data="input_data={\"username\":\"${REGRU_USERNAME}\",\"password\":\"${REGRU_PASSWORD}\",\"domains\":[{\"dname\":\"${DOMAIN}\"}],\"subdomain\":\"${SUBDOMAIN}\",\"text\":\"$3\",\"output_content_type\":\"plain\"}&input_format=json&show_input_params=0" \
      https://api.reg.ru/api/regru2/zone/add_txt 2>&1) || true

    check_response "$RESPONSE" "add_txt"
    ;;
  "cleanup")
    echo "Cleanup: subdomain=${SUBDOMAIN}.${DOMAIN}, value=$3"

    RESPONSE=$(wget -qO- \
      --header="Content-Type: application/x-www-form-urlencoded" \
      --post-data="input_data={\"username\":\"${REGRU_USERNAME}\",\"password\":\"${REGRU_PASSWORD}\",\"domains\":[{\"dname\":\"${DOMAIN}\"}],\"subdomain\":\"${SUBDOMAIN}\",\"record_type\":\"TXT\",\"content\":\"$3\",\"output_content_type\":\"plain\"}&input_format=json&show_input_params=0" \
      https://api.reg.ru/api/regru2/zone/remove_record 2>&1) || true

    check_response "$RESPONSE" "remove_record"
    ;;
  *)
    echo "Error: unknown action '$1', expected 'present' or 'cleanup'" >&2
    exit 1
    ;;
esac
