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

sub look_for_datastoreid {
	my $self = shift;
	my $dsid = shift;
	my @res = grep { $self->{coll}{$_}->{datastoreid} eq $dsid } keys %{$self->{coll}};
	return @res;
}

1;
