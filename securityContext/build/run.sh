#! /bin/bash -e

set -eou pipefail

#检查系统
check_sys(){
    if cat /etc/issue | grep -q -E -i "Alpine"; then
        release="alpine"
    else
        release="not-alpine"
    fi
}

if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
    mkdir -p ${JVM_LOGS}
    check_sys
    # run as root
    if [ "$(id -u)" = '0' ]; then
        if [[ "${release}" == "alpine" ]]; then
            exec /sbin/tini /sbin/su-exec ${uid}:${gid} java ${APP_OPTS} ${JAVA_OPTS} ${JVM_ARGS} ${JVM_GC} ${JMX} -jar "${WORKDIR}/${JAR_FILE}" "$@"
        else
            exec /bin/tini /usr/bin/gosu ${uid} -- java ${APP_OPTS} ${JAVA_OPTS} ${JVM_ARGS} ${JVM_GC} ${JMX} -jar "${WORKDIR}/${JAR_FILE}" "$@"
        fi
    # run as non-root
    else
        if [[ "${release}" == "alpine" ]]; then
            exec /sbin/tini java ${APP_OPTS} ${JAVA_OPTS} ${JVM_ARGS} ${JVM_GC} ${JMX} -jar "${WORKDIR}/${JAR_FILE}" "$@"
        else
            exec /bin/tini -- java ${APP_OPTS} ${JAVA_OPTS} ${JVM_ARGS} ${JVM_GC} ${JMX} -jar "${WORKDIR}/${JAR_FILE}" "$@"
        fi
    fi
fi

# As argument is not java application, assume user want to run his own process, for example a `bash` shell to explore this image
exec "$@"
