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
    local basename=$(basename $HUGO_REPO_BRANCH)
    local filename=${basename%.*}
    REPO_DIR="${REPO_DIR}${filename}"

    logInfo "clone ${HUGO_REPO_URL} -> ${REPO_DIR}"
    git clone --recursive -b ${HUGO_REPO_BRANCH:-master} ${HUGO_REPO_URL} ${REPO_DIR}
}


function updateRepo() {
    cd $REPO_DIR
    logInfo "update ${REPO_DIR}"
    git fetch && git pull
}


function runHugo() {
    logInfo "Try to start hugo"
    logInfo "/usr/local/bin/hugo -s ${REPO_DIR} ${HUGO_IGNORE_CACHE} -d ${NGINX_HTML_VOLUME}"
    time /usr/local/bin/hugo -s ${REPO_DIR} ${HUGO_IGNORE_CACHE} -d ${NGINX_HTML_VOLUME}
}


function runWebhook() {
    logInfo "Try to start webhook"
    logInfo "/usr/local/bin/webhook -hooks /etc/webhook/hooks.json -verbose"
    /usr/local/bin/webhook -hooks /etc/webhook/hooks.json -verbose
}

checkEnv

case "$1" in
run)
    cloneRepo
    runHugo
    runWebhook
    ;;
webhook)
    updateRepo
    runHugo
    ;;
esac