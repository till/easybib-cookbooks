#!/bin/sh
US_COUNT=$(cat /etc/apt/sources.list|grep -a 'us.'|wc -l)
if [ $US_COUNT -gt 0 ]; then
    sed -i 's/us.archive.ubuntu.com/de.archive.ubuntu.com/g' /etc/apt/sources.list
    apt-get -f -qq -y update
else
    echo "Skipping - seems OK already!"
fi

