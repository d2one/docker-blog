#!/usr/bin/env bash
# DNS challenge exec solver for Let's Encrypt via reg.ru API.
# Credentials are passed via environment variables REGRU_USERNAME and REGRU_PASSWORD.

set -e

case "$1" in
  "present")
    echo "Present"
    payload="{\"host\":\"$2\", \"value\":\"$3\"}"
    echo "payload=${payload}"
    curl --location 'https://api.reg.ru/api/regru2/zone/add_txt' \
--form 'input_data="{\"username\":\"'"${REGRU_USERNAME}"'\",\"password\":\"'"${REGRU_PASSWORD}"'\",\"domains\":[{\"dname\":\"d2one.ru\"}],\"subdomain\":\"@\",\"text\":\"'"$3"'\",\"output_content_type\":\"plain\"}"' \
--form 'input_format="json"' \
--form 'show_input_params="0"'
    ;;
  "cleanup")
    echo "cleanup"
    payload="{\"host\":\"$2\"}"
    echo "payload=${payload}"
    curl --location 'https://api.reg.ru/api/regru2/zone/remove_record' \
--form 'input_data="{\"username\":\"'"${REGRU_USERNAME}"'\",\"password\":\"'"${REGRU_PASSWORD}"'\",\"domains\":[{\"dname\":\"d2one.ru\"}],\"subdomain\":\"@\",\"record_type\":\"TXT\",\"content\":\"'"$3"'\",\"output_content_type\":\"plain\"}"' \
--form 'input_format="json"' \
--form 'show_input_params="0"'
    ;;
  *)
    echo "OOPS"
    ;;
esac
