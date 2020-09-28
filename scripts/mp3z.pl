#!/usr/bin/perl

# This is for albums that we only have in mp3 form
# Things this does (in order)
# Create missing index.txt files
# Scale cover.jpg to cover-170.jpg


$FORCE = 0;
$FORCEINDEX = 0;

$basedir = "/Users/tljohnsn/Public/music/";
@albumdirs = qw(mp3zlaptop convertedflacs);
$mp3dir = "/home/ftp/incoming/mp3";

%RENAME = ( "Alan Jackson" => "Jackson, Alan",
	    "Alanis Morissette" => "Morissette, Alanis",
	    "Barry White" => "White, Barry",
	    "Ben Harper" => "Harper, Ben",
	    "Ben Folds" => "Folds, Ben",
	    "Bob Dylan" => "Dylan, Bob",
	    "Bonnie Raitt" => "Raitt, Bonnie",
	    "Calvin Johnson" => "Johnson, Calvin",
	    "Celine Dion" => "Dion, Celine",
	    "Charlie Rich" => "Rich, Charlie",
	    "Chuck Berry" => "Berry, Chuck",
	    "David Allan Coe" => "Coe, David Allan",
	    "David Bowie" => "Bowie, David",
	    "Ella Fitzgerald" => "Fitzgerald, Ella",
	    "Elliott Smith" => "Smith, Elliott",
	    "Eric Clapton", => "Clapton, Eric",
	    "Faith Hill", "Hill, Faith",
	    "Frank Sinatra", "Sinatra, Frank",
	    "George Clinton", "Clinton, George",
	    "George Harrison", "Harrison, George",
	    "George Jones", "Jones, George",
	    "George Michael", "Michael, George",
	    "George Strait", "Strait, George",
	    "Jack Johnson", "Johnson, Jack",
	    "Jason Nevins", "Nevins, Jason",
	    "Jeff Buckley", "Buckley, Jeff",
	    "Jethro Tull", "Tull, Jethro",
	    "Jim Croce", "Croce, Jim",
	    "Jimi Hendrix", "Hendrix, Jimi",
	    "Jimmy Buffett", "Buffett, Jimmy",
	    "John Coltrane", "Coltrane, John",
	    "John Frusciante", "Frusciante, John",
	    "John Michael Montgomery", "Montgomery, John Michael",
	    "Johnny Cash", "Cash, Johnny",
	    "Johnny Duncan", "Duncan, Johnny",
	    "Julio Iglesias", "Iglesias, Julio",
	    "Kenny Chesney", "Chesney, Kenny",
	    "LeAnn Rimes", "Rimes, LeAnn",
	    "Lucinda Williams", "Williams, Lucinda",
	    "Lee Ann Womack", "Womack, Lee Ann",
	    "Lenny Kravitz", "Kravitz, Lenny",
	    "Liz Phair", "Phair, Liz",
	    "Lou Reed", "Reed, Lou",
	    "Michael Bolton", "Bolton, Michael",
	    "Miles Davis", "Davis, Miles",
	    "Missy Elliott", "Elliott, Missy",
	    "Natalie Cole", "Cole, Natalie",
	    "Neal McCoy", "McCoy, Neil",
	    "Neil Diamond", "Diamond, Neil",
	    "Neil Young", "Young, Neil",
	    "Norah Jones", "Jones, Norah",
	    "Patsy Cline", "Cline, Patsy",
	    "Pete Yorn", "Yorn, Pete",
	    "Ray Charles", "Charles, Ray",
	    "Reba McEntire", "McEntire, Reba",
	    "Roy Orbison", "Orbison, Roy",
	    "Shania Twain", "Twain, Shania",
	    "Stephen Malkmus", "Malkmus, Stephen",
	    "Stevie Wonder", "Wonder, Stevie",
	    "Talib Kweli", "Kweli, Talib",
	    "Tanya Tucker", "Tucker, Tanya",
	    "Tina Turner", "Turner, Tina",
	    "Tom Jones", "Jones, Tom",
	    "Tracy Byrd", "Byrd, Tracy",
	    "Tracy Chapman", "Chapman, Tracy",
	    "Van Morrison", "Morrison, Van",
	    "Vince Gill", "Gill, Vince",
	    "Willie Nelson", "Nelson, Willie",
	    "Wyclef Jean", "Jean, Wyclef"
);

my $albumcount = 0;
foreach $albumdir (@albumdirs) {
    print("find $basedir/$albumdir -name \"._*\" -print0 | xargs -0 rm");
    system("find $basedir/$albumdir -name \"._*\" -print0 | xargs -0 rm");
    system("find $basedir/$albumdir -name \".DS_Store*\" -print0 | xargs -0 rm");
    opendir(DIR,"$basedir/$albumdir");
    foreach $file (readdir(DIR)){
        if (!($file =~ /AppleDouble/) && $file ne "Live Shows" && $file ne "." && $file ne ".." && $file ne "LiveShows"
            && !($file =~ /lost\+found/) && $file ne ".sync" ){
            $albumcount++;
            if (-d "$basedir/$albumdir/$file") {
		$theDirectory = $file;
		$dash = index($file," - ");
                $artist = substr($file,0,$dash);
		$sortartist = $artist;
                $title = substr($file,$dash+3);
		$path = $albumdir . "/" . $file;

		#if ($RENAME{$artist} ne ""){
		#    $artist = $RENAME{$artist};
		#}

		if (lc(substr($artist,0,4)) eq "the "){
                    $sortartist = substr($artist,4) . ", The";
                } elsif (lc(substr($artist,0,2)) eq "a "){
                    $sortartist = substr($artist,2) . ", A";
                }

		opendir(ALBUMDIR,$basedir ."/" . $path);
		@files = readdir(ALBUMDIR);
		@files = sort(@files);
		my $cnt = 0;
		close(ALBUMDIR);

		# Look for cover, if not found, try to get it
		if (! (-e "$basedir/$path/cover.jpg")) {
		    print "finding image $basedir/$path\n";
		    system("/home/tljohnsn/amazon-cover.pl -d \"$basedir/$path\"");
		}
		#convert image
		if ($FORCE || ! (-e "$basedir/$path/cover-170.jpg")){
		    system("convert \"$basedir/$path/cover.jpg\" -resize 170x170 \"$basedir/$path/cover-170.jpg\"");
		}

		#retag everything if index.txt does not exist
		$resettags = 0;
		if ( ! (-e "$basedir/$path/index.txt") ) {
		    if (-e "$basedir/$path/cover.jpg" ) {
			$resettags = 1;
		    } else {
			print "Cover for $artist $title not found\nPlease download it manually\n";
		    }
		}

		#generate index file
		if ($FORCE || $FORCEINDEX ||  ! (-e "$basedir/$path/index.txt")){
		    open(FILE, "> $basedir/$path/index.txt");
		    print FILE ("artist $sortartist\ntitle $title\n\n");
		    $tracknum = 1;
		    foreach $file (@files) {
			if ($file =~ /\.mp3/) {
			    $sp = index($file," ");
			    $track = substr($file,0,$sp);
			    if ($track ne sprintf("%02d",$tracknum)) {
				print "Misssing song in $path\n";
			    }
			    printf FILE "%s\n%s\n",$file,substr($file,3,-4);
			    if ($resettags) {
				$song = substr($file,3,-4);
				$safefile = "$basedir/$path/$file";
				$safesong = $song;
				$safefile =~ s/\$/\\\$/; $safesong =~ s/\$/\\\$/;
				system("eyeD3 --remove-all \"$basedir/$path/$file\"");
				system("eyeD3 --to-v2.4 --force-update --remove-v1 -a \"$artist\" -A \"$title\" -t \"$safesong\" -n $tracknum  --add-image=\"$basedir/$path/cover-170.jpg\":FRONT_COVER \"$safefile\"");
			    }
			    $tracknum++;
			}
		    }
		    close(FILE);
		}
            }
        }
    }
}
