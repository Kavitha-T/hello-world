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
my @stash;
my $dbexisting = "exeterdb";
my $dbnew; 
my $sth;
my $sth2;
my $tbname;
my $tbrow;
my $n=0;
my $input;

#Connect to MySQL
my $dbh = DBI->connect($dsn,$username,$password);

#get dbname from user
print "Enter a name to create database:\n";
chomp($dbnew = <>);

#create db based on userinput - 
$sth = $dbh->do("CREATE DATABASE $dbnew DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci") 
or die "SQL Error : $DBI::errstr \n";

#list all tables from database
print "\nList of tables in the database $dbexisting  \n";
$sth = $dbh->prepare("SHOW TABLES FROM $dbexisting");
$sth->execute() or die "SQL Error: $DBI::errstr \n";

while ($tbrow = $sth->fetchrow_array())
 {
       
	  
	   print "$tbrow\n";
	 push (@stash, $tbrow);
 	 
}

print "\n";
foreach $tbrow ( @stash ) 
   {
   #open the ini-file 
      @lines = read_file("tableconfig.ini");

	     #Split line into words - word[0] = tablename, word[1] = copytype
	     @words = split /[|]/, $lines[$n];
		 $tbname = $words[0];
		
     		 
		 #copy only the table structure if copytype is 1
		 if ($words[1] == 1)
		 {
		     $sth = $dbh->prepare("CREATE TABLE $dbnew.$tbname LIKE $dbexisting.$tbname");
             $sth->execute() or die "SQL Error : $DBI::errstr \n";
			 print "Table structure created for $tbname.\n";
			  print "Press enter to continue : \n";
			 $input = <>;
			 
		 }
		 
		 #copy the table structure and data if copytype is 2
		 if ($words[1] == 2)
         {

             $sth = $dbh->prepare("CREATE TABLE IF NOT EXISTS $dbnew.$tbname LIKE $dbexisting.$tbname");
			 $sth->execute() or die "SQL Error : $DBI::errstr \n";
			 
			 $sth2 = $dbh->prepare("INSERT IGNORE INTO $dbnew.$tbname SELECT * FROM $dbexisting.$tbname");
             $sth2->execute() or die "SQL Error : $DBI::errstr \n";
			 
			 print "Table data copied for $tbname.\n";
             print "Press enter to continue : \n";
			 $input = <>;
         } 
		 
     $n++;
	}
 print "Finished \n ";


