use warnings;
use strict;
use 5.010;
use XML::XPath;

package GSDatadir::WMSLayer;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	bless ($self, $class);
	$self->{gc} = shift;
	$self->{xml} = shift;
	$self->{title} = undef;
	$self->{name} = undef;
	$self->{stylename} = undef;
	$self->parse;
	return $self;
}

sub parse {
	my $self = shift;
	$self->{id} = $self->{xml}->find('Name')->string_value;
	$self->{title} = $self->{xml}->find('Title')->string_value;
	$self->{stylename} = $self->{xml}->find('Style/Name')->string_value;
}

sub dump {
	my $self = shift;
	say "WMSLayer: id=$self->{id}, title=$self->{title}, stylename=$self->{stylename}"
}

sub check {
	my $self = shift;
	# XXX check that id and stylename reference workspace:layer & workspace:style
	# check GetLegendGraphics return code ?
	return 0;
}

1;
