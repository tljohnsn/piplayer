#!/bin/bash
curl -b "currenthost=Default;player_backend=mpd" http://localhost/rompr/api/collection/?rebuild=yes > /dev/null

