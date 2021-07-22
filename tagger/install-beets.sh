#!/bin/bash
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

brew install chromaprint

mkdir -p ~/{.config/beets,data}
cp ~/piplayer/tagger/config.yaml ~/.config/beets

