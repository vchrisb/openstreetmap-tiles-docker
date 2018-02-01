#!/bin/sh

##
# Run OpenStreetMap tile server operations
#

# Command prefix that runs the command as the web user
asweb="setuser www-data"

die () {
    msg=$1
    echo "FATAL ERROR: " msg > 2
    exit
}

_startservice () {
    sv start $1 || die "Could not start $1"
}

import () {
    # Find the most recent import.pbf or import.osm
    import=$( ls -1t /data/import.pbf /data/import.osm 2>/dev/null | head -1 )
    test -n "${import}" || \
        die "No import file present: expected /data/import.osm or /data/import.pbf"

    echo "Importing ${import} into gis"
    echo "$OSM_IMPORT_CACHE" | grep -P '^[0-9]+$' || \
        die "Unexpected cache type: expected an integer but found: ${OSM_IMPORT_CACHE}"

    number_processes=`nproc`

    # Limit to 8 to prevent overwhelming pg with connections
    if test $number_processes -ge 8
    then
        number_processes=8
    fi

    $asweb osm2pgsql --slim --hstore --cache $OSM_IMPORT_CACHE --database gis --number-processes $number_processes $import
}

cli () {
    echo "Running bash"
    cd /var/www
    exec bash
}

startservices () {
    _startservice renderd
    _startservice apache2
}

_wait () {
    WAIT=$1
    NOW=`date +%s`
    BOOT_TIME=`stat -c %X /etc/container_environment.sh`
    UPTIME=`expr $NOW - $BOOT_TIME`
    DELTA=`expr 5 - $UPTIME`
    if [ $DELTA -gt 0 ]
    then
	sleep $DELTA
    fi
}

# Unless there is a terminal attached wait until 5 seconds after boot
# when runit will have started supervising the services.
if ! tty --silent
then
    _wait 5
fi

# Execute the specified command sequence
for arg
do
    $arg;
done

# Unless there is a terminal attached don't exit, otherwise docker
# will also exit
if ! tty --silent
then
    # Wait forever (see
    # http://unix.stackexchange.com/questions/42901/how-to-do-nothing-forever-in-an-elegant-way).
    tail -f /dev/null
fi
