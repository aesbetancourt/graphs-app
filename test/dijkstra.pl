# create the object
use warnings;
use strict;
use Graph::Dijkstra;
my $graph = Graph::Dijkstra->new( {edgedefault=>'directed'} );

#SET methods to create graph nodes and edges "manually"

$graph->node( {id=>0, label=>'node 0'} );
$graph->node( {id=>1, label=>'node 1'} );
$graph->node( {id=>2, label=>'node 2'} );
$graph->node( {id=>3, label=>'node 3'} );
$graph->edge( {sourceID=>0, targetID=>1, weight=>2} );
$graph->edge( {sourceID=>1, targetID=>2, weight=>9} );
$graph->edge( {sourceID=>1, targetID=>3, weight=>4} );
$graph->edge( {sourceID=>3, targetID=>2, weight=>1} );
#
# $graph->outputGraphtoCSV('mygraphfile.csv');
# $graph->outputGraphtoJSON('mygraphfile.json');

use Data::Dumper;
my %Solution = ();

#shortest path to farthest node from origin node
%Solution = ( originID=>1 , destinationID=>2 );
if ( my $pathCost = $graph->shortestPath(\%Solution) ) {
    print "Solution path from originID $Solution{originID} to destinationID $Solution{destinationID} at weight (cost) $Solution{weight}\n";
    foreach my $edgeHref (@{$Solution{edges}}) {
        print "\tsourceID='$edgeHref->{sourceID}' targetID='$edgeHref->{targetID}' weight='$edgeHref->{weight}'\n";
    }
}