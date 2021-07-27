#!/usr/bin/perl

# Things this does (in order)
# Create missing index.txt files
# Scale cover.jpg to cover-170.jpg
# Convert to mp3

$FORCE = 0;
$FORCEINDEX = 0;

$basedir = "/Music/";
@albumdirs = qw(flacmini);
$mp3dir = "/Music/convertedflacs";

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
    system("find $basedir/$albumdir -name \"._*\" -print0 | xargs -0 rm");
    system("find $basedir/$albumdir -name \".DS_Store*\" -print0 | xargs -0 rm");
    opendir(DIR,"$basedir/$albumdir");
    foreach $file (readdir(DIR)){
        if (!($file =~ /AppleDouble/) && $file ne "Live Shows" && $file ne "." && $file ne ".." && $file ne "LiveShows" && $file ne ".sync"
            && !($file =~ /lost\+found/) ){
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

		#generate index file
		if ($FORCE || $FORCEINDEX ||  ! (-e "$basedir/$path/index.txt")){
		    open(FILE, "> $basedir/$path/index.txt");
		    print FILE ("artist $sortartist\ntitle $title\n\n");
		    $tracknum = 1;
		    foreach $file (@files) {
			if ($file =~ /\.flac/) {
			    $sp = index($file," ");
			    $track = substr($file,0,$sp);
			    if ($track ne sprintf("%02d",$tracknum)) {
				print "Bitching about $path\n";
			    }
			    printf FILE "%s\n%s\n",$file,substr($file,3,-5);
			    $tracknum++;
			}
		    }
		    close(FILE);
		}
		# Look for cover, if not found, try to get it
		if ( -z "$basedir/$path/cover.jpg") {
		    unlink "$basedir/$path/cover.jpg";
		}

		if (! (-e "$basedir/$path/cover.jpg")) {
		    print "finding image $basedir/$path\n";
		    system("/home/tljohnsn/amazon-cover.pl -d \"$basedir/$path\"");
		}
		#convert image
		if ($FORCE || ! (-e "$basedir/$path/cover-170.jpg")){
		    system("convert \"$basedir/$path/cover.jpg\" -resize 170x170 \"$basedir/$path/cover-170.jpg\"");
		}
		#make directory
		if ($FORCE || ! (-e "$mp3dir/$theDirectory")){
		    print "Creating $theDirectory\n";
		    mkdir("$mp3dir/$theDirectory", 0777);
		}
		#copy covers
		if ($FORCE || !(-e "$mp3dir/$theDirectory/cover.jpg")){
		    system("cp \"$basedir/$path/cover.jpg\" \"$mp3dir/$theDirectory\"/ ");
		}
                if ($FORCE || !(-e "$mp3dir/$theDirectory/cover-170.jpg")){
		    system("cp \"$basedir/$path/cover-170.jpg\" \"$mp3dir/$theDirectory\"/ ");
		}
		#convert to mp3
		foreach $file (@files) {
		    if ($file =~ /\.flac/) {
			$base = $file;
			$base =~ s/\.flac$//;
			$input = "$basedir/$path/$file";
			$output = "$mp3dir/$theDirectory/$base.mp3";
			$tracknum = substr($base, 0, 2);
			$safesong = substr($file, 3, -5);
			if ($FORCE || !(-e $output)){
			    $command1 = "flac --silent -d -c \"$input\" -o \"/tmp/$base.wav\"";
			    $command2 = "lame -quiet \"/tmp/$base.wav\" \"$output\"";
			    $command3 = "flac --silent -d -c \"$input\" | lame --quiet - \"$output\"";
			    print "Doing $output\n";
			    if (-e $output) {
				print "And deleting\n";
				system("rm \"$output\"");
			    }
			    #system($command1 );
			    #system($command2 );
			    system($command3 );
#			    system("eyeD3 --remove-all \"$output\"");
			    $date =`date +%Y-%m-%dT%H:%M:%S`;
			    chomp($date);
			    print("eyeD3 --to-v2.4 --force-update --remove-v1 -a \"$artist\" -b \"$artist\" -A \"$title\" -t \"$safesong\" -n $tracknum --tagging-date $date --add-image=\"$basedir/$path/cover.jpg\":FRONT_COVER \"$output\"\n");
			    system("eyeD3 --to-v2.4 --force-update --remove-v1 -a \"$artist\" -b \"$artist\" -A \"$title\" -t \"$safesong\" -n $tracknum --tagging-date $date  --add-image=\"$basedir/$path/cover.jpg\":FRONT_COVER \"$output\"");
			    system("rm \"/tmp/$base.wav\"");
			}
		    }
		}

		# Generate mp3 index file
                if ($FORCE || $FORCEINDEX || ! (-e "$mp3dir/$path/index.txt")){
                    open(FILE, "> $mp3dir/$theDirectory/index.txt");
                    print FILE "artist $sortartist\ntitle $title\n\n";
                    foreach $file (@files) {
			if ($file =~ /\.flac/) {
			    $base = $file;
			    $base =~ s/\.flac$//;
			    $file = $base . ".mp3";
			    $sp = index($file," ");
			    $track = substr($file,0,$sp);
			    printf FILE "%s\n%s\n",$file,substr($file,3,-4);
			}
                    }
                    close(FILE);
                }
            }
        }
    }
    system("find $basedir/$albumdir -print0 | perl -n0e 'chomp; print $_, \"\n\" if /[[:^ascii:][:cntrl:]]/'");
}
