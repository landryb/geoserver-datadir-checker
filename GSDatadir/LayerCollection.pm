use warnings;
use strict;
use 5.010;

package GSDatadir::LayerCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::Layer;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args);
	$self->{glob} = "$self->{path}/workspaces/*/*/*/layer.xml";
	return $self;
}

sub itemtype { return "GSDatadir::Layer"; }

sub look_for_styleid {
	my $self = shift;
	my $styleid = shift;
	my @res = grep { $self->{coll}{$_}->{defaultstyleid} eq $styleid } keys %{$self->{coll}};
	return @res;
}

sub look_for_featuretypeid {
	my $self = shift;
	my $ftid = shift;
	my @res = grep { $self->{coll}{$_}->{featuretypeid} eq $ftid } keys %{$self->{coll}};
	return @res;
}
1;
