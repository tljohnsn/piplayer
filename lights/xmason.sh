#!/bin/bash
source /boot/tunes.txt
curl -X PUT -d '{"on":true}' http://10.0.2.30/api/$huekey/lights/10/state
curl -X PUT -d '{"on":true}' http://10.0.2.30/api/$huekey/lights/12/state
curl -X PUT -d '{"on":true}' http://10.0.2.30/api/$huekey/lights/13/state
curl -X PUT -d '{"on":true}' http://10.0.2.30/api/$huekey/lights/14/state
#For ceramic tree:
#curl -X PUT -d '{"on":true, "bri":254}' http://10.0.2.30/api/$huekey/lights/2/state
