use warnings;
use strict;
use 5.010;

package GSDatadir::VectorDataCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::VectorData;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args);
	$self->{glob} = "find ".$self->{path}." -iname *.shp";
	return $self;
}

sub itemtype { return "GSDatadir::VectorData"; }

sub list {
	my $self = shift;
	foreach (`$self->{glob}`) {
		chomp;
		$self->{coll}{$_} = GSDatadir::VectorData->new($self->{gc}, $_);
	}
}

sub check {
	my $self = shift;
	my %hash_by_sha = ();
	foreach (keys %{$self->{coll}}) {
		push @{$hash_by_sha{$self->{coll}{$_}->{sha256}}}, $_;
	}
	foreach (keys %hash_by_sha) {
		my @vd = @{$hash_by_sha{$_}};
		if ($#vd > 0) {
			say "same sha256 ($_) for @vd";
			foreach (@vd) {
				say "of those, $_ is unreferenced" unless ($self->{coll}{$_}->{referenced_by});
			}
		}
	}
	$self->SUPER::check();
}
1;
