#!/bin/bash
curl -b "currenthost=Default;player_backend=mopidy" http://localhost/rompr/api/collection/?rebuild=yes > /dev/null

