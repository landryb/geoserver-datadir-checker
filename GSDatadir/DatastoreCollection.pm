use warnings;
use strict;
use 5.010;

package GSDatadir::DatastoreCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::Datastore;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args);
	$self->{glob} = "$self->{path}/workspaces/*/*/datastore.xml";
	return $self;
}

sub itemtype { return "GSDatadir::Datastore"; }

sub look_for_connurl {
	my $self = shift;
	my $url = shift;
	my @res = grep { $self->{coll}{$_}->{connurl} eq $url } keys %{$self->{coll}};
	return @res;
}
1;
