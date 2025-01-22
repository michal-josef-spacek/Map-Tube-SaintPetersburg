package Map::Tube::SaintPetersburg;

use strict;
use warnings;
use 5.006;

use File::Share ':all';
use Moo;
use namespace::clean;

# Version.
our $VERSION = 0.07;

# Get XML.
has xml => (
	'is' => 'ro',
	'default' => sub {
		return dist_file('Map-Tube-SaintPetersburg', 'saint_petersburg-map.xml');
	},
);

with 'Map::Tube';

1;

__END__

=encoding utf8

=head1 NAME

Map::Tube::SaintPetersburg - Interface to the Saint Petersburg Metro Map.

=head1 SYNOPSIS

 use Map::Tube::SaintPetersburg;
 my $obj = Map::Tube::SaintPetersburg->new;
 my $routes_ar = $obj->get_all_routes($from, $to);
 my $line = $obj->get_line_by_id($line_id);
 my $line = $obj->get_line_by_name($line_name);
 my $lines_ar = $obj->get_lines;
 my $station = $obj->get_node_by_id($station_id);
 my $station = $obj->get_node_by_name($station_name);
 my $route = $obj->get_shortest_route($from, $to);
 my $stations_ar = $obj->get_stations($line);
 my $metro_name = $obj->name;
 my $xml_file = $obj->xml;

=head1 DESCRIPTION

It currently provides functionality to find the shortest route between the two
given nodes.

For more information about Saint Petersburg Map, click L<here|https://en.wikipedia.org/wiki/Saint_Petersburg_Metro>.

=head1 METHODS

=over 8

=item C<new()>

 Constructor.

=item C<get_all_routes($from, $to)> [EXPERIMENTAL]

 Get all routes from station to station.
 Returns reference to array with Map::Tube::Route objects.

=item C<get_line_by_id($line_id)>

 Get line object defined by id.
 Returns Map::Tube::Line object.

=item C<get_line_by_name($line_name)>

 Get line object defined by name.
 Returns Map::Tube::Line object.

=item C<get_lines()>

 Get lines in metro map.
 Returns reference to unsorted array with Map::Tube::Line objects.

=item C<get_node_by_id($station_id)>

 Get station node by id.
 Returns Map::Tube::Node object.

=item C<get_node_by_name($station_name)>

 Get station node by name.
 Returns Map::Tube::Node object.

=item C<get_shortest_route($from, $to)>

 Get shortest route between $from and $to node names. Node names in $from and $to are case insensitive.
 Returns Map::Tube::Route object.

=item C<get_stations($line)>

 Get list of stations for concrete metro line.
 Returns reference to array with Map::Tube::Node objects.

=item C<name()>

 Get metro name.
 Returns string with metro name.

=item C<xml()>

 Get XML specification of Saint Petersburg metro.
 Returns string with XML.

=back

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Encode qw(decode_utf8 encode_utf8);
 use Map::Tube::SaintPetersburg;

 # Object.
 my $obj = Map::Tube::SaintPetersburg->new;

 # Get route.
 my $route = $obj->get_shortest_route(decode_utf8('Лесная'), decode_utf8('Озерки'));

 # Print out type.
 print "Route: ".encode_utf8($route)."\n";

 # Output:
 # Route: Лесная (Кировско-Выборгская линия), Выборгская (Кировско-Выборгская линия), Площадь Ленина (Кировско-Выборгская линия), Чернышевская (Кировско-Выборгская линия), Площадь Восстания (Кировско-Выборгская линия), Владимирская (Кировско-Выборгская линия), Пушкинская (Кировско-Выборгская линия), Технологический институт (Кировско-Выборгская линия,Московско-Петроградская линия), Сенная площадь (Московско-Петроградская линия), Невский проспект (Московско-Петроградская линия), Горьковская (Московско-Петроградская линия), Петроградская (Московско-Петроградская линия), Чёрная речка (Московско-Петроградская линия), Пионерская (Московско-Петроградская линия), Удельная (Московско-Петроградская линия), Озерки (Московско-Петроградская линия)

=head1 EXAMPLE2

 use strict;
 use warnings;

 use Map::Tube::SaintPetersburg;

 # Object.
 my $obj = Map::Tube::SaintPetersburg->new;

 # Get XML file.
 my $xml_file = $obj->xml;

 # Print out XML file.
 print "XML file: $xml_file\n";

 # Output like:
 # XML file: .*/saint_petersburg-map.xml

=head1 EXAMPLE3

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
 # -rw-r--r-- 1 skim skim 207926 Feb 18 07:13 SaintPetersburg.png

=begin html

<a href="https://raw.githubusercontent.com/tupinek/Map-Tube-SaintPetersburg/master/images/ex3.png">
  <img src="https://raw.githubusercontent.com/tupinek/Map-Tube-SaintPetersburg/master/images/ex3.png" alt="Петербургский метрополитен" width="300px" height="300px" />
</a>

=end html

=head1 EXAMPLE4

 use strict;
 use warnings;

 use Encode qw(encode_utf8);
 use Map::Tube::SaintPetersburg;

 # Object.
 my $obj = Map::Tube::SaintPetersburg->new;

 # Get lines.
 my $lines_ar = $obj->get_lines;

 # Print out.
 map { print encode_utf8($_->name)."\n"; } sort @{$lines_ar};

 # Output:
 # Кировско-Выборгская линия
 # Московско-Петроградская линия
 # Невско-Василеостровская линия
 # Правобережная линия
 # Фрунзенско-Приморская линия

=head1 EXAMPLE5

 use strict;
 use warnings;

 use Encode qw(decode_utf8 encode_utf8);
 use Map::Tube::SaintPetersburg;

 # Arguments.
 if (@ARGV < 1) {
         print STDERR "Usage: $0 line\n";
         exit 1;
 }
 my $line = decode_utf8($ARGV[0]);

 # Object.
 my $obj = Map::Tube::SaintPetersburg->new;

 # Get stations for line.
 my $stations_ar = $obj->get_stations($line);

 # Print out.
 map { print encode_utf8($_->name)."\n"; } @{$stations_ar};

 # Output:
 # Usage: __PROG__ line

 # Output with 'foo' argument.
 # Map::Tube::get_stations(): ERROR: Invalid Line Name [foo]. (status: 105) file __PROG__ on line __LINE__

 # Output with 'Правобережная линия' argument.
 # Спасская
 # Достоевская
 # Лиговский проспект
 # Площадь Александра Невского-2
 # Новочеркасская
 # Ладожская
 # Проспект Большевиков
 # Улица Дыбенко

=head1 DEPENDENCIES

L<File::Share>,
L<Map::Tube>,
L<Moo>,
L<namespace::clean>.

=head1 SEE ALSO

=over

=item L<Map::Tube>

Core library as Role (Moo) to process map data.

=item L<Task::Map::Tube>

Install the Map::Tube modules.

=item L<Task::Map::Tube::Metro>

Install the Map::Tube concrete metro modules.

=back

=head1 REPOSITORY

L<https://github.com/tupinek/Map-Tube-SaintPetersburg>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2014-2017 Michal Josef Špaček

Artistic License

BSD 2-Clause License

=head1 VERSION

0.07

=cut
