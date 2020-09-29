#!/bin/bash
find /home/ftp/local -name ".DS_Store" -print0 | xargs -0 rm -rf
find /home/ftp/local -name ".sync" -print0 | xargs -0 rm -rf
find /home/ftp/local -name "._*" -print0 | xargs -0 rm -rf
chown -R pi.pi /home/ftp/local/{mp3zpi,convertedflacspi}
chmod -R 777 /home/ftp/local
