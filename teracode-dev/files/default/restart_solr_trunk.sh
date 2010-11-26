#!/bin/sh

killall java
sleep 3
ps -A | grep java
if [ $? -eq 0 ]; then
        echo 'solr has not been closed correctly'
        exit
fi
cd /solr/solr-trunk-compiled
java -Xmx4096m -Xms4096m -Xmn256m -jar start.jar 2> /dev/null &

