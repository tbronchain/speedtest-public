# speedtest

author: Thibault Bronchain
thibault <at> bronchain <dot> me

## requirements

The router should be unix based (OpenWrt and DD-Wrt should both work fine).

The restart.sh script should be put on the router, under the /root directory

The run.sh script should be run somewhere on the local network (a home server, NAS or rasberry pi would do a rgeat job here).

The ssh key of that server/user has to be accepted by the router.

The "SERVER_URI" variable on run.sh script should be specified. 2 files must be present on this server (100k.bin and 10M.bin), with the appropriate weight. They can be easily generated with "dd" and served by nginx.

The test will pass is the speed of the current connection ~15mbps. This speed can be changed by setting the "sleep" next to "change here to set speed" - but "7" seems to be a great working value.

The script will terminate by itself once the connection is acceptable.

It is preferable to run the script when not using the connection. The script may take a while...
