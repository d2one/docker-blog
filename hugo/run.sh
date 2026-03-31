#!/bin/bash

REPO_DIR=/home/
HUGO_IGNORE_CACHE="--ignoreCache"

function logError() {
    echo "[error] ${1}"
}


function logInfo() {
    echo "[info] ${1}"
}


function logWarning() {
    echo "[warning] ${1}"
}


function optionalVariable() {
    if [ -z "${!1}" ]
    then
        logWarning "\${${1}} is not set; using default value '${2}'"
        eval ${1}=${2}
    fi
}

function requiredVariable() {
    if [ -z "${!1}" ]
    then
        logError "\${${1}} is not set"
        exit 1
    fi
}

function checkEnv() {
    requiredVariable HUGO_REPO_URL
    requiredVariable NGINX_HTML_VOLUME
    optionalVariable HUGO_REPO_BRANCH master

    if [[ ! -d "${NGINX_HTML_VOLUME}" ]]
    then
        logWarning "nginx dir not found."
        exit 1
    fi;
}


function cloneRepo() {
    local basename=$(basename $HUGO_REPO_URL)
    local filename=${basename%.*}
    REPO_DIR="${REPO_DIR}${filename}"

    logInfo "clone ${HUGO_REPO_URL} -> ${REPO_DIR}"
    git clone --recursive -b ${HUGO_REPO_BRANCH:-master} ${HUGO_REPO_URL} ${REPO_DIR}
}


function updateRepo() {
    local basename=$(basename $HUGO_REPO_URL)
    local filename=${basename%.*}
    REPO_DIR="${REPO_DIR}${filename}"
    cd $REPO_DIR
    logInfo "update ${REPO_DIR}"

    git fetch && git reset --hard origin/${HUGO_REPO_BRANCH:-master}
}


function runHugo() {
    logInfo "Try to start hugo"

    local config_file=""
    if [ -f "${REPO_DIR}/hugo.toml" ]; then
        config_file="${REPO_DIR}/hugo.toml"
    elif [ -f "${REPO_DIR}/hugo.yaml" ]; then
        config_file="${REPO_DIR}/hugo.yaml"
    elif [ -f "${REPO_DIR}/config.toml" ]; then
        config_file="${REPO_DIR}/config.toml"
    elif [ -f "${REPO_DIR}/config.yaml" ]; then
        config_file="${REPO_DIR}/config.yaml"
    else
        logError "No Hugo config file found (tried hugo.toml, hugo.yaml, config.toml, config.yaml)"
        return 1
    fi

    logInfo "Using config: ${config_file}"

    local hugo_theme=$(grep -Eo "theme *= *\"(.*)\"" "${config_file}" | grep -o '".*"' | sed -e 's/\"//g')

    local hugo_cmd="hugo -s ${REPO_DIR} -d ${NGINX_HTML_VOLUME} ${HUGO_IGNORE_CACHE}"
    if [ -n "${hugo_theme}" ]; then
        hugo_cmd="${hugo_cmd} --theme=${hugo_theme}"
    fi

    logInfo "${hugo_cmd}"
    time ${hugo_cmd}

    if [ $? -ne 0 ]; then
        logError "Hugo build failed"
        return 1
    fi

    logInfo "Hugo build completed successfully"
}


function runWebhook() {
    logInfo "Try to start webhook"
    envsubst < /etc/webhook/hooks.json > /tmp/hooks.json
    logInfo "/usr/local/bin/webhook -hooks /tmp/hooks.json -verbose"
    /usr/local/bin/webhook -hooks /tmp/hooks.json -verbose
}

checkEnv

case "$1" in
run)
    cloneRepo
    runHugo || { logError "Hugo build failed, not starting webhook"; exit 1; }
    runWebhook
    ;;
webhook)
    updateRepo
    runHugo || { logError "Hugo rebuild failed"; exit 1; }
    ;;
esac
