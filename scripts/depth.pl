#!/usr/bin/perl
use strict;
use DateTime;
use IO::Socket::INET;
use List::Util qw(sum);


my $socket = new IO::Socket::INET(
    PeerHost => '10.0.4.182',
    PeerPort => '10110',
    Protocol  => 'tcp'
) or die "Socket konnte nicht erstellt werden!\n$!\n";
my $datestring=`gpspipe -w -n 10 |grep time |tail -n1 | cut -d\",\" -f3 | cut -c9-27`;
chomp($datestring);
$datestring="$datestring" . "Z\n";
print "sudo date -s $datestring";
system("sudo date -s \"`gpspipe -w -n 10 |grep time |tail -n1 | cut -d"," -f3 | cut -c9-27`Z\"");
system("sudo date -s $datestring");
print("The time is set to:\n");
system("date");
print "Client kommuniziert auf Port 5005\n";
my $dt = DateTime->now;
$dt->set_time_zone('America/New_York');
my $prevfive = int($dt->minute/5);
my @depths = ();
while (my $line = $socket->getline) {
    if ($line=~ /DBT/){
	$dt = DateTime->now;
	$dt->set_time_zone('America/New_York');
	my $five = int($dt->minute/5);
	my @data=split(",",$line);
	my $datestring=$dt->datetime();
	$datestring = $dt->ymd('-') . ' ' . $dt->hms(':');
	print "$datestring $five Depth is $data[1]\n"; # do whatever with your data here
	if ($prevfive != $five) {
	    my $average = sum(@depths)/@depths;
	    my $filename = "//home/pi/data";
	    open(FH, '>>', $filename) or die $!;
	    print "$datestring $five averave Depth is $average\n";
	    my $data = "$datestring $average\n";
	    print FH $data;
	    close(FH);
	    $prevfive = $five;
	    @depths =();
	} else {
	    push (@depths, $data[1]);
	}
    }
}
