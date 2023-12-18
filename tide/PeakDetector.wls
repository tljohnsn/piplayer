#!/usr/bin/env wolframscript
(* ::Package:: *)

Clear[test,times,vals,peaks,troughs,blur];

test=Import["/Users/tljohnsn/piplayer/tide/tide-2023-02-15-thompsonbayy","Data"];

times=DateObject/@StringRiffle/@test[[All,1;;-2]];
vals=ToExpression[test[[All,-1]]];
data=Transpose[{times,vals}];
series=TimeSeries[data];
blur=50;
peaks=FindPeaks[series,blur];
troughs=FindPeaks[-series,blur];
Print["Peaks may be at:
"<>StringRiffle[DateString/@peaks["Times"],"
"] <> "
" <>
"Troughs may be at:
"<> StringRiffle[DateString/@troughs["Times"],"
"]]
