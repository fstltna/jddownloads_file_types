#!/usr/bin/perl

# This tool scans all the entries in the jddownloads database to set
# icon to the type for that file

use strict;
use warnings;
use DBI;
use DBD::mysql;


# No changes below here
my $CurTitle="";
my $CurAlias="";
my $CurFilePic="";
my $CurFileName="";
my $CurId=0;
my $CurStatus="";
my $timeout=5;
my $VERSION="1.0.0";
my $DB_Owner="";
my $DB_Pswd="";
my $DB_Name="";
my $DB_Prefix="";
my $DB_Table="";
my $dbh;
my $CONF_FILE="$ENV{HOME}/.scanjdsettings.ini";
my $CurNotify="";
my $CurName="";
my $email="";
my $IconDir="/var/www/html/images/jdownloads/fileimages/flat_1/";
my $UnknownType = "unknown";
my $FILEEDITOR = $ENV{EDITOR};

if (! defined($FILEEDITOR))
{
        $FILEEDITOR = "vi";
}
elsif ($FILEEDITOR eq "")
{
        $FILEEDITOR = "vi";
}

# Get if they said a option
my $CMDOPTION = shift;

# Read in configuration options
if (! -f $CONF_FILE)
{
	my $DefaultConf = <<'END_MESSAGE';
DB_User	root
DB_Pswd	foobar
DB_DBName	joomla
DB_DBtblpfx	zzz_
END_MESSAGE
	open (my $FH, ">", $CONF_FILE) or die "Could not create config file '$CONF_FILE' $!";
        print $FH "$DefaultConf\n";
	close($FH);
	system("$FILEEDITOR $CONF_FILE");
	exit 0;
}

open(CONF, "<$CONF_FILE") || die("Unable to read config file '$CONF_FILE'");
while(<CONF>)
{
	chop;
	if ($_ eq "")
	{
		next;
	}
	my ($FIELD_TYPE, $FIELD_VALUE) = split (/	/, $_);
	#print("Type is $FIELD_TYPE\n");
	if (! defined($FIELD_TYPE))
	{
		# Field type not defined
		print "Field type not defined for '$_'\n";
		next;
	}
	if ($FIELD_TYPE eq "DB_User")
	{
		$DB_Owner = $FIELD_VALUE;
	}
	elsif ($FIELD_TYPE eq "DB_Pswd")
	{
		$DB_Pswd = $FIELD_VALUE;
	}
	elsif ($FIELD_TYPE eq "DB_DBName")
	{
		$DB_Name = $FIELD_VALUE;
	}
	elsif ($FIELD_TYPE eq "DB_DBtblpfx")
	{
		$DB_Prefix = $FIELD_VALUE;
	}
}
close(CONF);

print("listmissing ($VERSION)\n");
print("===========================================\n");

if (defined $CMDOPTION)
{
        if ($CMDOPTION ne "prefs")
        {
                print "Unknown command line option: '$CMDOPTION'\nOnly allowed option is 'prefs'\n";
                exit 0;
        }
	system("$FILEEDITOR $CONF_FILE");
	exit 0;
}

### The database handle
$dbh = DBI->connect ("DBI:mysql:database=$DB_Name:host=localhost",
                           $DB_Owner,
                           $DB_Pswd) 
                           or die "Can't connect to database: $DBI::errstr\n";

$DB_Table = $DB_Prefix . "jdownloads_files";

### The statement handle
my $sth = $dbh->prepare("SELECT id, title, alias, file_pic, url_download FROM $DB_Table");

$sth->execute or die $dbh->errstr;

my $rows_found = $sth->rows;

while (my $row = $sth->fetchrow_hashref)
{
	$CurId = $row->{'id'};
	$CurTitle = $row->{'title'};
	$CurAlias = $row->{'alias'};
	$CurFilePic = $row->{'file_pic'};
	$CurFileName = $row->{'url_download'};
	# print "Saw $CurTitle\n";
	if ($CurFilePic eq "unknown.png")
	{
		my $DotPos = rindex($CurFileName, ".");
		if ($DotPos == 0)
		{
			print "Did not see a dot in $CurFileName\n";
			next;
		}
		my $FileType = substr($CurFileName, $DotPos + 1);
		if ($FileType eq "")
		{
			next;
		}
		#print "icontype = $CurFilePic\n";
		#print "curfilename = $CurFileName\n";
		print "Need icon type: '$FileType'\n";
	}
}
exit(0);
