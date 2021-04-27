#! /bin/bash

if [ ! -d "sites/frappe.localtest.me" ]
then
    echo 'sleeping 15 seconds for mysql to start'
    sleep 15
    echo creating new site frappe.localtest.me
    bench new-site \
        --db-host mariadb \
        --mariadb-root-password root \
        --admin-password admin \
        --db-name frappe \
        frappe.localtest.me
fi

exec bench start