#!/usr/bin/env perl

use strict;
use warnings;

use Map::Tube::GraphViz;
use Map::Tube::GraphViz::Utils qw(node_color_without_label);
use Map::Tube::SaintPetersburg;

# Object.
my $obj = Map::Tube::SaintPetersburg->new;

# GraphViz object.
my $g = Map::Tube::GraphViz->new(
        'callback_node' => \&node_color_without_label,
        'tube' => $obj,
);

# Get graph to file.
$g->graph('SaintPetersburg.png');

# Print file.
system "ls -l SaintPetersburg.png";

# Output like:
# -rw-r--r-- 1 skim skim 200586 23. led 11.50 SaintPetersburg.png