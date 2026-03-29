#!/usr/bin/env sh
# DNS challenge exec solver for Let's Encrypt via reg.ru API.
# Credentials are passed via environment variables REGRU_USERNAME and REGRU_PASSWORD.

set -e

DOMAIN="d2one.ru"

case "$1" in
  "present")
    SUBDOMAIN=$(echo "$2" | sed "s/\.${DOMAIN}$//")
    echo "Present: subdomain=${SUBDOMAIN}, value=$3"

    wget -qO- \
      --header="Content-Type: application/x-www-form-urlencoded" \
      --post-data="input_data={\"username\":\"${REGRU_USERNAME}\",\"password\":\"${REGRU_PASSWORD}\",\"domains\":[{\"dname\":\"${DOMAIN}\"}],\"subdomain\":\"${SUBDOMAIN}\",\"text\":\"$3\",\"output_content_type\":\"plain\"}&input_format=json&show_input_params=0" \
      https://api.reg.ru/api/regru2/zone/add_txt

    ;;
  "cleanup")
    SUBDOMAIN=$(echo "$2" | sed "s/\.${DOMAIN}$//")
    echo "Cleanup: subdomain=${SUBDOMAIN}, value=$3"

    wget -qO- \
      --header="Content-Type: application/x-www-form-urlencoded" \
      --post-data="input_data={\"username\":\"${REGRU_USERNAME}\",\"password\":\"${REGRU_PASSWORD}\",\"domains\":[{\"dname\":\"${DOMAIN}\"}],\"subdomain\":\"${SUBDOMAIN}\",\"record_type\":\"TXT\",\"content\":\"$3\",\"output_content_type\":\"plain\"}&input_format=json&show_input_params=0" \
      https://api.reg.ru/api/regru2/zone/remove_record

    ;;
  *)
    echo "OOPS"
    ;;
esac