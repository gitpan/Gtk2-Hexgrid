package Gtk2::Hexgrid::Item;
use Carp;
use warnings;
use strict;

sub new{
    my $class = shift;
    my $type = shift;
    
    my $self= {
        tile => undef,
        type => $type,
        priority => 0
    };
    if ($type eq 'text'){
        $self->{text} = shift;
        $self->{size} = shift; #font size, such as 18
    }
    elsif($type eq 'image'){
        my $name = shift;
        croak 'image needs name' unless $name;
        $self->{imageName} = $name;
    }
    bless $self, $class;
    return $self;
}

sub copy{
    my $self = shift;
    my %copy = %$self;
    return \%copy;
}
#attach to tile
sub attach{
    my ($self, $tile) = @_;
    $tile->add_item($self);
}
#detach from tile
sub detach{
    my $self = shift;
    my $tile = $self->tile;
    $tile->remove_item();
}
sub set_priority{ #place in the drawing order
    my ($self, $p) = @_;
    $self->{priority} = $p;
}
sub _set_tile{ #the tile that it it attached to
    my ($self, $tile) = @_;
    $self->{tile} = $tile;
}

sub imageName{
    shift->{imageName}
}

sub tile{
    shift->{tile}
}
sub type{
    shift->{type}
}
sub text{
    shift->{text}
}
sub size{
    shift->{size}
}
sub priority{
    shift->{priority}
}
q ! positively!
__END__

=head1 NAME

Gtk2::Hexgrid::Tile - a hexagonal tile from a Hexgrid

=head1 SYNOPSIS

 my $item1 = $tile->set_background("images/squid.png");
 my $item2 = $tile->set_text("blah", 18);
 my $item3 = new Gtk2::Hexgrid::Item("text", "blah", 15);
 my $item4 = new Gtk2::Hexgrid::Item("image", "imageName");
 $item4->set_priority(5);
 $item4->set_tile($tile);

=head1 METHODS

=head2 new

 my $item3 = new Gtk2::Hexgrid::Item("text", "blah", 15);
 my $item4 = new Gtk2::Hexgrid::Item("image", "imageName");

The type, "text" or "image", is in the first field.
If "text", the text and font size are in the next fields.
If 'image', the image name is in the next field.
The image name is used as a key to the actual image.
Images are loaded by Gtk2::Hexgrid::load_image.

=head2 copy

 my $newItem = $item->copy();

Returns a clone of caller item.

=head2 accessors

=over

=item tile

=item type

=item text

=item size

=item priority

=item imageName

=back

=head2 detach

 $item->detach;

Removes self from its parent and starts floating in space

=head2 attach

 $item->attach($tile);

Performs a detach in reverse.

=head2 set_priority

Each item has a priority, the default being 0. Items with lower
priorities are drawn before items with higher priorities.
I've given backgrounds a priority of -21.21, and text is 21.21. 
They are not round numbers because items with the same priority are
prioritized by thich item was attached first, and that may cause weird behavior.

=cut
