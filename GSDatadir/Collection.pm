use warnings;
use strict;
use 5.010;

package GSDatadir::Collection;

sub new {
	my $class = shift;
	my $self = {};
	$self->{gc} = shift;
	$self->{path} = shift;
	$self->{itemtype} = shift;
	$self->{coll} = undef;
	return bless ($self, $class);
}

sub list {
	my $self = shift;
	foreach (glob "$self->{glob}") {
		say "itemtype=$self->{itemtype}, $_";
		my $item = "GSDatadir::$self->{itemtype}"->new($self->{gc}, $_);
		$self->{coll}{$item->{id}} = $item;
	}
}
sub get_item {
	my $self = shift;
	my $id = shift;
	return $self->{coll}{$id};
}

sub dump {
	my $self = shift;
	my @a = keys %{$self->{coll}};
	say "$self->{itemtype}Collection: path=$self->{path}, glob=$self->{glob}, ".($#a + 1)." items";
	foreach (@a) {
		say "$self->{itemtype}:$_";
		$self->{coll}{$_}->dump;
	}
}

sub check {
	my $self = shift;
	my @err = ();
	foreach (keys %{$self->{coll}}) {
		if ($self->{coll}{$_}->check < 0) {
			push @err, $_;
			say "$_ has an issue";
		}
	}
}
1;
