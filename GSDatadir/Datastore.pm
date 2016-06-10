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
	$self->{id} = $xp->getNodeText('/dataStore/id')->value;
	$self->{name} = $xp->getNodeText('/dataStore/name')->value;
	$self->{type} = $xp->getNodeText('/dataStore/type')->value;
	$self->{enabled} = $xp->getNodeText('/dataStore/enabled')->value;
	$self->{workspaceid} = $xp->getNodeText('/dataStore/workspace/id')->value;
	$self->{connurl} = $xp->getNodeText('/dataStore/connectionParameters/entry[@key="url"]')->value;
	if ($self->{connurl} && substr($self->{connurl}, 0, 6) ne "file:/") {
		my $basedir = $self->{gc}->{ds}->{path};
#		say "fixing connurl ($self->{connurl}) for $self->{id}, prepending $basedir";
		$self->{connurl} = "file:$basedir/".substr($self->{connurl}, 5);
	}
	# make sure connurl has a trailing /
	if ($self->{connurl} && substr($self->{connurl}, -1) ne "/") {
		say "adding trailing / to $self->{connurl} for $self->{id}";
		$self->{connurl}.='/';
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
		warn "Datastore '$self->{name}' ($self->{name}) is disabled ??\n";
	}
	if ($self->{type} eq "Shapefile" or $self->{type} eq "Directory of spatial files (shapefiles)") {
		my $path = $self->{connurl};
		$path =~ s/^file://;
		my $basedir = $self->{file};
		$basedir =~ s/workspaces.*//;
		if (! -d $path && ! -d "$basedir$path" && ! -f $path && ! -f "$basedir$path") {
			say "Datastore '$self->{name}' ($self->{id}) references a non-existent directory/file: {$basedir,}$path";
			return -1;
		}
		# XX look for VectorData items under this $path if dir
	}
	unless ($workspace) {
		say "Datastore '$self->{name}' ($self->{id}) references a non-existent workspace: $self->{workspaceid}";
		return -1;
	}
	$self->{workspace} = \$workspace;
	my @ft = $self->{gc}->{ft}->look_for_datastoreid($self->{id});
	unless (@ft) {
		say "Datastore '$self->{name}' ($self->{id}) isnt referenced by any featuretype";
		return -1;
	}
	$self->{referenced_by} = \@ft;
	return 0;
}
1;
