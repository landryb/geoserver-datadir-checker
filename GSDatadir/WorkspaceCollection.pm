use warnings;
use strict;
use 5.010;

package GSDatadir::WorkspaceCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::Workspace;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args);
	$self->{glob} = "$self->{path}/workspaces/*/workspace.xml";
	return $self;
}

sub itemtype { return "GSDatadir::Workspace"; }

1;
