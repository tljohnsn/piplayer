#!/bin/bash
mv HARMONICS_NO_US_Consort.tcd HARMONICS_NO_US_Consort.tcd.old
build_tide_db HARMONICS_NO_US_Consort.tcd HARMONICS_NassauOnly.txt HARMONICS_Consort.xml
