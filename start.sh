#!/bin/sh

sed -i \
    -e "/^default_password_crypted/ s|:.*$|: \"${DEFAULT_ROOT_PASSWD}\"|" \
    -e "/^next_server/ s/:.*$/: ${NEXT_SERVER}/" \
    -e "/^server/ s/:.*$/: ${HOST_ADDRESS}/" \
    /etc/cobbler/settings

bootstrap() {
    timeout=10

    while ! nc -z localhost 25151; do
        sleep 1
        timeout=$((${timeout} - 1))
        if [ ${timeout} -eq 0 ]; then
            echo "ERROR: cobblerd is not running."
            exit 1
        fi
    done

    cobbler get-loaders
    cobbler sync
    cobbler check
}

bootstrap &

/usr/bin/supervisord -c /etc/supervisord.conf
