#! /bin/bash
set -e

SITENAME=${FRAPPE_SITE_NAME:-frappe.localhost}

if [ ! -d "sites/$SITENAME" ]
then
    echo 'sleeping 15 seconds for mysql to start'
    sleep 15
    echo creating new site $SITENAME
    bench new-site \
        --db-host mariadb \
        --mariadb-root-password root \
        --admin-password admin \
        --db-name frappe \
        $SITENAME

    # add a new line as the apps.txt doesn't have an ending new line
    echo >> sites/apps.txt
    for app in $FRAPPE_APPS
    do
        echo "== installing app $app =="
        echo $app >> sites/apps.txt
        (cd apps/$app && ../../env/bin/python setup.py develop)
        bench --site $SITENAME install-app $app
    done

    if [ "$FRAPPE_ALLOW_TESTS" == "true" ]
    then
        echo "setting allow_tests true"
        bench --site $SITENAME set-config allow_tests true
    fi
fi

exec bench start