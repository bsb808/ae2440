echo on
word = "Banana";
indexes = strfind(word, "a")
indexes = strfind(word, "na")
found = contains(word, "a")
found = contains(word, "b")
found = contains(word, "b", "IgnoreCase",true)

gpsheading = "$HCHDG,123.4,0.0,E,5.5,W*3C";
parts = split(gpsheading, ",")

hdg = str2num(parts(2))
direction = str2num(parts(4))



echo off