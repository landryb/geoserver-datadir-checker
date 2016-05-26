use warnings;
use strict;
use 5.010;
use XML::XPath;

package GSDatadir::Datastore;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	my $file = shift;
	$self->{file} = $file;
	$self->{id} = undef;
	$self->{name} = undef;
	$self->{type} = undef;
	$self->{enabled} = undef;
	$self->{workspaceid} = undef;
	$self->{connurl} = undef;
	$self->parse;
	return $self;
}

sub parse {
	my $self = shift;
	my $xp = XML::XPath->new(filename => $self->{file});
	$self->{id} = $xp->getNodeText('/dataStore/id');
	$self->{name} = $xp->getNodeText('/dataStore/name');
	$self->{type} = $xp->getNodeText('/dataStore/type');
	$self->{enabled} = $xp->getNodeText('/dataStore/enabled');
	$self->{workspaceid} = $xp->getNodeText('/dataStore/workspace/id');
	$self->{connurl} = $xp->getNodeText('/dataStore/connectionParameters/entry[@key="url"]');
	if ($self->{connurl} && substr($self->{connurl}, 0, 6) ne "file:/") {
		my $basedir = $self->{gc}->{ds}->{path};
#		say "fixing connurl ($self->{connurl}) for $self->{id}, prepending $basedir";
		$self->{connurl} = "file:$basedir/".substr($self->{connurl}, 5);
	}
}

sub dump {
	my $self = shift;
	say "Datastore: file=$self->{file}, id=$self->{id}, name=$self->{name}, type=$self->{type}, connurl=$self->{connurl}"
}

sub check {
	my $self = shift;
	my $workspace = $self->{gc}->{ws}->get_item($self->{workspaceid});
	unless ($self->{enabled} eq "true") {
		warn "$self->{id}/$self->{name} is disabled ??\n";
	}
	if ($self->{type} eq "Shapefile" or $self->{type} eq "Directory of spatial files (shapefiles)") {
		my $path = $self->{connurl};
		$path =~ s/^file://;
		my $basedir = $self->{file};
		$basedir =~ s/workspaces.*//;
		if (! -d $path && ! -d "$basedir$path" && ! -f $path && ! -f "$basedir$path") {
			say "$self->{id}/$self->{name} references a non-existent directory/file: {$basedir,}$path";
			return -1;
		}
		# XX look for VectorData items under this $path if dir
	}
	unless ($workspace) {
		say "$self->{id}/$self->{name} references a non-existent workspace: $self->{workspaceid}";
		return -1;
	}
	$self->{workspace} = \$workspace;
	return 0;
}
1;
