#!/usr/bin/perl
#

use Socket;
use DBD::mysql;
use DBI();
use Time::Local;
use Getopt::Std;
use Sys::Syslog ;
use File::Spec;
use Net::Telnet ();

my $nas = '10.33.254.16';
my $logfile = 'input.log';
my $passwd = 'xxxxyyyyy';
my $username = 'root';
my $Description = '';
my $UpTime ='';
my $Name = '';
my $Location = '';
my $MAC = '';
my $test = '';


    my $sw = new Net::Telnet (Timeout => 30, Prompt  => '/#.*$/', Errmode => 'return' );
    # log output
    $sw->input_log($logfile);
    if ($sw->open("$nas"))
{
    $sw -> waitfor( '/ame[: ]*$/' );
    $sw -> print( $username );
    $sw -> waitfor( '/ord[: ]*$/' );
    $sw -> print( $passwd );
    ($prompt, undef) = $sw -> waitfor('/#.*$/');
    $sw->cmd("terminal datadump");

    @lines = $sw->cmd("show system");
    #my @lines = $sw -> waitfor('/#.*$/');
    #($l1, $l2) = $sw->waitfor('/\s+3993(\s+)permanent\s+/');
#    print @lines;

foreach $line (@lines)
{
    my ($id, $value) = split (/\s{6,}/,$line);
    chomp ($id, $value);
    if ($id=~/Description/ ) { $Description = $value; }
    if ($id=~/Up Time/ )  { $UpTime = $value; }
    if ($id=~/Name/ )  { $Name = $value; }
    if ($id=~/Location/ )  { $Location = $value; }
    if ($id=~/MAC/ )  { $MAC = $value; }
}
    $sw->cmd("exit");
    $sw->close;
} else { print "Error connect to $nas\n"; }

print "\nResult: $Description | $UpTime | $Name | $Location | $MAC\n";

exit;
