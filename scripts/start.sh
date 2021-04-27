#! /bin/bash
set -e

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

    # add a new line as the apps.txt doesn't have an ending new line
    echo >> sites/apps.txt
    for app in $FRAPPE_APPS
    do
        echo "== installing app $app =="
        echo $app >> sites/apps.txt
        (cd apps/$app && ../../env/bin/python setup.py develop)
        bench --site frappe.localtest.me install-app $app
    done
fi

exec bench start