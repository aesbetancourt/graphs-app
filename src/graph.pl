use strict;
use warnings FATAL => 'all';
use Mojolicious::Lite;

get '/' => 'index';

app->start;
__DATA__

@@ index.html.ep
<html lang="es">
  <head>
    <title>Grafos</title>
    %= javascript 'https://rawgit.com/chen0040/js-graph-algorithms/master/third-party-libs/vis/vis.js'
    %= javascript 'https://rawgit.com/chen0040/js-graph-algorithms/master/src/jsgraphs.js'
    %= stylesheet 'https://rawgit.com/chen0040/js-graph-algorithms/master/third-party-libs/vis/vis.css'
  </head>
  <body>
    <h2>Weighted DiGraph</h2>
    %= input_tag 'nodes', placeholder => 'Nro de nodos', id => 'nodos'
    %= input_tag 'edges', placeholder => 'Patron de aristas'
    %= submit_button 'Generar', id => 'render', onclick => 'renderGraph()'
    %= tag 'div', id => 'mynetwork'
    %= javascript begin
       function renderGraph() {
        var nd = document.getElementById("nodos");
        var g = new jsgraphs.WeightedDiGraph(nd.value);
        g.addEdge(new jsgraphs.Edge(0, 1, 5.0));
        g.addEdge(new jsgraphs.Edge(0, 4, 9.0));
        g.addEdge(new jsgraphs.Edge(0, 7, 8.0));
        g.addEdge(new jsgraphs.Edge(1, 2, 12.0));
        g.addEdge(new jsgraphs.Edge(1, 3, 15.0));
        g.addEdge(new jsgraphs.Edge(1, 7, 4.0));
        g.addEdge(new jsgraphs.Edge(2, 3, 3.0));
        g.addEdge(new jsgraphs.Edge(2, 6, 11.0));
        g.addEdge(new jsgraphs.Edge(3, 6, 9.0));
        g.addEdge(new jsgraphs.Edge(4, 5, 5.0));
        g.addEdge(new jsgraphs.Edge(4, 6, 20.0));
        g.addEdge(new jsgraphs.Edge(4, 7, 5.0));
        g.addEdge(new jsgraphs.Edge(5, 2, 1.0));
        g.addEdge(new jsgraphs.Edge(5, 6, 13.0));
        g.addEdge(new jsgraphs.Edge(7, 5, 6.0));
        g.addEdge(new jsgraphs.Edge(7, 2, 7.0));


        var dijkstra = new jsgraphs.Dijkstra(g, 0);



        var g_nodes = [];
        var g_edges = [];
        for(var v=0; v < g.V; ++v){
            g.node(v).label = 'Node ' + v; // assigned 'Node {v}' as label for node v
            g_nodes.push({
                id: v,
                label: g.node(v).label
            });
        }

        for(var v = 1; v < g.V; ++v){
            if(dijkstra.hasPathTo(v)){
                var path = dijkstra.pathTo(v);
                console.log('=====path from 0 to ' + v + ' start==========');
                for(var i = 0; i < path.length; ++i) {
                    var e = path[i];
                    console.log(e.from() + ' => ' + e.to() + ': ' + e.weight);
                    g_edges.push({
                        from: e.from(),
                        to: e.to(),
                        length: e.weight,
                        label: '' + e.weight,
                        arrows:'to',
                        color: '#00ff00'
                    });
                }
                console.log('=====path from 0 to ' + v + ' end==========');
                console.log('=====distance: '  + dijkstra.distanceTo(v) + '=========');
            }
        }

        for(var v=0; v < g.V; ++v) {
            var adj_v = g.adj(v);
            for(var i = 0; i < adj_v.length; ++i) {
                var e = adj_v[i];
                var w = e.other(v);
                g_edges.push({
                    from: v,
                    to: w,
                    length: e.weight,
                    label: '' + e.weight,
                    arrows:'to'
                });
            };
        }

        console.log(g.V); // display 6, which is the number of vertices in g
        console.log(g.adj(0)); // display [5, 1, 2], which is the adjacent list to vertex 0

        var nodes = new vis.DataSet(g_nodes);

        // create an array with edges
        var edges = new vis.DataSet(g_edges);

        // create a network
        var container = document.getElementById('mynetwork');
        var data = {
            nodes: nodes,
            edges: edges
        };
        var options = {};
        var network = new vis.Network(container, data, options);
    }
    % end
</body>
</html>