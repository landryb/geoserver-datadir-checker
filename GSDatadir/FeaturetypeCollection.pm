use warnings;
use strict;
use 5.010;

package GSDatadir::FeaturetypeCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::Featuretype;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args);
	$self->{glob} = "$self->{path}/workspaces/*/*/*/featuretype.xml";
	return $self;
}

sub itemtype { return "GSDatadir::Featuretype"; }

1;
