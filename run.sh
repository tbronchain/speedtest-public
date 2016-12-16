#!/bin/bash

FILE_LOG="/tmp/ips_log.txt"

SERVER_URI="http://myserver.com"
FILE_TEST="100k.bin"
FILE_SPEED="10M.bin"
URI_TEST="${SERVER_URI}/${FILE_TEST}"
URI_SPEED="${SERVER_URI}/${FILE_SPEED}"
PATH_TEST="/tmp/${FILE_TEST}"
PATH_SPEED="/tmp/${FILE_SPEED}"

ROUTER_IP="192.168.1.1"

echo -n > $FILE_LOG

COUNTER=0
while :
do
    if [ $COUNTER -ge 50 ]; then
        echo "$(date) - Too many trials, restarting router"
        ssh root@$ROUTER_IP restart
        sleep 120
        COUNTER=0
    else
        let COUNTER=COUNTER+1
    fi
    IP=$(ssh root@$ROUTER_IP "ifconfig | grep pppoe-wan -A 1 | grep addr | cut -d ':' -f 2 | cut -d ' ' -f 1")
    if [ "$IP" != "" ]; then
        echo "$(date) - Testing IP: $IP" >> $FILE_LOG
    else
        echo "$(date) - Connection failed (no ip)." >> $FILE_LOG
        sleep 10
        continue
    fi

    wget --timeout=10 $URI_TEST -O $PATH_TEST
    if [ "$?" != "0" ]; then
        echo "$(date) - Connection failed (can't download)." >> $FILE_LOG
        sleep 10
        continue
    fi

    wget --timeout=10 $URI_SPEED -O $PATH_SPEED &
    PID=$!
    sleep 7 #change here to set speed
    RUNNING=$(ps ax | grep $PID | grep wget | wc -l)
    if [ "$RUNNING" = "0" ]; then
        echo "$(date) - Connection succeed!" >> $FILE_LOG
        break
    else
        kill $PID
        echo "$(date) - Too slow, reconnecting..." >> $FILE_LOG
        ssh root@$ROUTER_IP /root/restart.sh
    fi
    sleep 60
done

rm $PATH_SPEED
rm $PATH_TEST

# EOF
