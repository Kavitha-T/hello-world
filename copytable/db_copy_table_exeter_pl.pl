#!usr/bin/perl
$num_args = $#ARGV + 1;
if ($num_args != 2) {
    print "\nUsage: name.pl first_name last_name\n";
    exit;
}
 

use strict;
use File::Slurp;
use DBI;
use List::MoreUtils;


my $driver = "mysql";
my $database = "";
my $dsn = "DBI:$driver:database=$database";
my $username = "root";
my $password = "";


my @lines;
my @stash;
my @tbrow;
my @structure;
my $structure;
my $dbexisting = "exeterdb";
my $dbnew=$ARGV[1];
my $sth;
my $sth2;
my $tbname;
my $tbrow;
my $nrows = 1;
my $totrows;

#Connect to MySQL
my $dbh = DBI->connect($dsn,$username,$password);


#create new db based on userinput - 
$sth = $dbh->do("CREATE DATABASE $dbnew DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci") 
or die print "<script>alert('Database $dbnew already exist')</script>";
 print "<script>alert('New Database Created in the name $dbnew')</script>";


$sth = $dbh->prepare("SHOW TABLES FROM $dbexisting");
$sth->execute() or die "SQL Error: $DBI::errstr \n";

#total tables in the existing db
$totrows = $sth->rows();
print "Total Number of Tables: $totrows <br>";

#list all tables from the existing database
print "List of tables <br>";
while ($tbrow = $sth->fetchrow_array())
 {
     print "$nrows . $tbrow <br>";
	 push (@tbrow,  $tbrow );
 	 $nrows++;
	   
}

print"\n";

#check if table is found in config file
foreach $tbname(@tbrow)
{
@lines = read_file("tableconfig3.ini");
chomp(@lines);
while (<@lines>)
  { 
  if(/$tbname/)
       {
             push (@stash,  $tbname );
       }
  }
}

#remove duplicates and save it in structure array
my %temp_hash = map { $_, 0 } @stash;
my @structure = keys %temp_hash;	
foreach $tbname(@structure)
 {           
             #create structure for tables found in config file 
             $sth = $dbh->prepare("CREATE TABLE IF NOT EXISTS $dbnew.$tbname LIKE $dbexisting.$tbname");
             $sth->execute();
			 
			 print "<script>alert('Table structure created for $tbname . Press OK to continue')</script>";
			
}

#remove the tables which are in config 
foreach $structure(@structure)
{ 
@tbrow = grep {!/$structure/} @tbrow;
}
foreach $tbname(@tbrow)
{
             #copy data for tables which are not found in config file 
             $sth = $dbh->prepare("CREATE TABLE IF NOT EXISTS $dbnew.$tbname LIKE $dbexisting.$tbname");
			 $sth->execute() or die "SQL Error : $DBI::errstr \n";
			 
			 $sth2 = $dbh->prepare("INSERT IGNORE INTO $dbnew.$tbname SELECT * FROM $dbexisting.$tbname");
             $sth2->execute() or die "SQL Error : $DBI::errstr \n";
			 
			 print "<script>alert('Table data copied for $tbname . Press OK to continue')</script>";
}

 print "<script>alert('Finished')</script>";