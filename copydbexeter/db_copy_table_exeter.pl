#!usr/bin/perl

use strict;
use warnings;
use File::Slurp;
use DBI;
use Config::Simple;

my $driver = "mysql";
my $database = "";
my $dsn = "DBI:$driver:database=$database";
my $username = "root";
my $password = "";


my @lines;
my @words;
my $dbexisting = "exeterdb";
my $dbnew; 
my $sth;
my $sth2;
my $tbname;
my $copytype;
my $n;
my $x;

#Connect to MySQL
my $dbh = DBI->connect($dsn,$username,$password);

#get dbname from user
print "Enter a name to create database:\n";
chomp($dbnew = <>);

#create db based on userinput - 
$sth = $dbh->do("CREATE DATABASE IF NOT EXISTS $dbnew DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci");


#open the ini-file of the existing db
@lines = read_file("tableconfig.ini");

#n no of lines in ini-file
$n = scalar(@lines);

 for($x=0;$x<=$n;$x++)
	{
	     #Split line into words - word[0] = tablename, word[1] = copytype
	     @words = split /[|]/, $lines[$x];
		 $tbname = $words[0];
		 $copytype = $words[1];
     		 
		 #copy only the table structure if copytype is 1
		 if ($copytype == 1)
		 {
		     $sth = $dbh->prepare("CREATE TABLE IF NOT EXISTS $dbnew.$tbname LIKE $dbexisting.$tbname");
             $sth->execute() or die "SQL Error : $DBI::errstr \n";
			 print "Table structure created for $tbname.\n";
		 }
		 
		 #copy the table structure and data if copytype is 2
		 if ($copytype == 2)
         {

             $sth = $dbh->prepare("CREATE TABLE IF NOT EXISTS $dbnew.$tbname LIKE $dbexisting.$tbname");
			 $sth->execute() or die "SQL Error : $DBI::errstr \n";
			 
			 $sth2 = $dbh->prepare("INSERT IGNORE INTO $dbnew.$tbname SELECT * FROM $dbexisting.$tbname");
             $sth2->execute() or die "SQL Error : $DBI::errstr \n";
			 
			 print "Table data copied for $tbname.\n";

         } 
		 

	}



