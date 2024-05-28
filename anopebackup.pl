#!/usr/bin/perl

# Set these for your situation
my $MTDIR = "/home/ircdaemon/services";
my $BACKUPDIR = "/home/ircdaemon/backups";
my $TARCMD = "/bin/tar czf";
my $VERSION = "1.0.0";
my $DOSNAPSHOT = 0;

# Get if they said a option
my $CMDOPTION = shift;

if (defined $CMDOPTION)
{
	if ($CMDOPTION ne "-snapshot")
	{
		print "Unknown command line option: '$CMDOPTION'\nOnly allowed options are '-snapshot'\n";
		exit 0;
	}
}

sub SnapShotFunc
{
	print "Backing up services files: ";
	if (-f "$BACKUPDIR/snapshot.tgz")
	{
		unlink("$BACKUPDIR/snapshot.tgz");
	}
	system("$TARCMD $BACKUPDIR/snapshot.tgz $MTDIR > /dev/null 2>\&1");
	print "\nBackup Completed.\n";
}

#-------------------
# No changes below here...
#-------------------

if ((defined $CMDOPTION) && ($CMDOPTION eq "-snapshot"))
{
	$DOSNAPSHOT = -1;
}

print "AnopeBackup.pl version $VERSION\n";
if ($DOSNAPSHOT == -1)
{
	print "Running Manual Snapshot\n";
}
print "==============================\n";

if (! -d $BACKUPDIR)
{
	print "Backup dir $BACKUPDIR not found, creating...\n";
	system("mkdir -p $BACKUPDIR");
}
if ($DOSNAPSHOT == -1)
{
	SnapShotFunc();
	exit 0;
}

print "Moving existing backups: ";

if (-f "$BACKUPDIR/anopebackup-5.tgz")
{
	unlink("$BACKUPDIR/anopebackup-5.tgz") or warn "Could not unlink $BACKUPDIR/anopebackup-5.tgz: $!";
}

my $FileRevision = 4;
while ($FileRevision > 0)
{
	if (-f "$BACKUPDIR/anopebackup-$FileRevision.tgz")
	{
		my $NewVersion = $FileRevision + 1;
		rename("$BACKUPDIR/anopebackup-$FileRevision.tgz", "$BACKUPDIR/anopebackup-$NewVersion.tgz");
	}
	$FileRevision -= 1;
}

print "Done\nCreating New Backup: ";
system("$TARCMD $BACKUPDIR/anopebackup-1.tgz $MTDIR");
print "Done\n";

exit 0;
