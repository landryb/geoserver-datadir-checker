use warnings;
use strict;
use 5.010;

package GSDatadir::SLDCollection;
use parent 'GSDatadir::Collection';
use GSDatadir::SLD;
use Data::Dumper;

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args);
	$self->{glob} = "$self->{path}/{workspaces/*/,}styles/*.sld";
	return $self;
}

sub itemtype { return "GSDatadir::SLD"; }

sub check {
	my $self = shift;
	$self->SUPER::check();
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
}
1;
