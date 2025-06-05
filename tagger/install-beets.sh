#!/bin/bash
export PATH="/usr/local/opt/ffmpeg@4/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/ffmpeg@4/lib"
export CPPFLAGS="-I/usr/local/opt/ffmpeg@4/include"

brew install curl ffmpeg@4 
brew install chromaprint eye-d3 mid3v2

pip3 install https://github.com/beetbox/beets/tarball/master

pip3 install beets-bpmanalyser
#beet bpmanalyser bpm:0

pip3 install pylast

pip3 install pyacoustid

pip3 install python-dateutil
cd
git clone git@github.com:kernitus/beets-oldestdate.git
cd beets-oldestdate/
python3 setup.py install

#cd
#git clone git@github.com:/mried/beetsplug.git
#cp beetsplug/beetsplug/autosingleton.py /usr/local/lib/python3.9/site-packages/beetsplug/

pip3 install requests
pip3 install --break-system-packages standard-aifc standard-sunau

mkdir -p ~/{.config/beets,data,mp3zstaging,mp3zrenamed}
cp ~/piplayer/tagger/config.yaml ~/.config/beets

