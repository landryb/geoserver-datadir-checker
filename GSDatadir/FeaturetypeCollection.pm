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

sub lookup_by_namespace_prefix_and_name {
	my $self = shift;
	my $prefix = shift;
	my $name = shift;
	my @res = grep {
		$self->{coll}{$_}->{name} eq $name and
		$self->{gc}->{ns}->get_item($self->{coll}{$_}->{namespaceid})->{prefix} eq $prefix } keys %{$self->{coll}};
	die "$#res items for $prefix:$name ? impossibru!" if ($#res > 0);
	return $res[0];
}
1;
