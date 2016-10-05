#!usr/bin/perl
$num_args = $#ARGV + 1;
if ($num_args != 2) {
    print "\nUsage: name.pl url site_name\n";
    exit;
}
 

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
my @row;
my $dbexisting = "exeterdb";
my $dbnew=$ARGV[1];
my $sth;
my $sth2;
my $tbname;
my $tbrow;
my $n=0;
my $nrows = 1;
my $totrows;
my $input;

#Connect to MySQL
my $dbh = DBI->connect($dsn,$username,$password);


#create db based on userinput - 


$sth = $dbh->do("CREATE DATABASE $dbnew DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci") 
or die print "<script>alert('Database $dbnew already exist')</script>";
 print "<script>alert('New Database Created in the name $dbnew')</script>";

 
#get existing dbname from user to copy
#print "\nEnter a database name form the list below: \n";
#


#list all tables from database

$sth = $dbh->prepare("SHOW TABLES FROM $dbexisting");
$sth->execute() or die "SQL Error: $DBI::errstr \n";
$totrows = $sth->rows();
print "Total Number of Tables: $totrows <br>";
print "List of tables <br>";
while ($tbrow = $sth->fetchrow_array())
 {
       
	  
	   print "$nrows . $tbrow <br>";
	 push (@stash,  $tbrow );
 	 $nrows++;
}

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
			 print "<script>alert('Table structure created for $tbname . Press OK to continue')</script>";
			 print "<script>alert('Hello\nHow are you?')</script>";
		 }
		 
		 #copy the table structure and data if copytype is 2
		 if ($words[1] == 2)
         {

             $sth = $dbh->prepare("CREATE TABLE IF NOT EXISTS $dbnew.$tbname LIKE $dbexisting.$tbname");
			 $sth->execute() or die "SQL Error : $DBI::errstr \n";
			 
			 $sth2 = $dbh->prepare("INSERT IGNORE INTO $dbnew.$tbname SELECT * FROM $dbexisting.$tbname");
             $sth2->execute() or die "SQL Error : $DBI::errstr \n";
			 
			print "<script>alert('Table data copied for $tbname . Press OK to continue')</script>";
			 
         } 
		 
     $n++;
	}
 print "<script>alert('Finished')</script>";


