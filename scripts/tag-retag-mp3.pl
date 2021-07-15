#!/usr/bin/perl -I .
#use MPEG::MP3Info;

$FORCE = 0;

$albumdir = "/home/ftp/local/mp3";

opendir(ALBUMS,"$albumdir");

while ($album = readdir(ALBUMS)) {
    if (($album ne "..") && ($album ne ".") && opendir(SHNS,"$albumdir/$album")) {
	# found a directory do this inside it

                #retag everything if index.txt does not exist                                                                    
	$resettags = 0;
	if ( ! (-e "$albumdir/$album/index.txt") ) {
	    if (! (-e "$albumdir/$album/cover.jpg" )) {
		print "Cover for $album not found\nPlease download it manually\n";
	    } else {
		while ($song = readdir(SHNS)) {
		    if ($song =~ /\.mp3$/) {
			$file = "$albumdir/$album/$song";
			($artist, $albumt) = split(/ - /, $album);
			$tracknum = substr($song,0,2);
			$song =~ s/\.mp3$//;
			$song =~ s/\s+$//;
			$song =~ s/^[0-9][0-9] //;
			print "Gonna retag  \"$file\"\n";
			$file =~ s/\$/\\\$/; $song =~ s/\$/\\\$/;
			$shit = `eyeD3 --remove-all \"$file\"`;
			$shit = `eyeD3 --to-v2.4  --remove-v1 -a \"$artist\" -A \"$albumt\" -t \"$song\" -n $tracknum  --add-image=\"$albumdir/$album/cover.jpg\":FRONT_COVER \"$file\"`;
		    }
		}
	    }
	}
    }
    closedir(SHNS);
}
closedir(ALBUMS);

exit;
