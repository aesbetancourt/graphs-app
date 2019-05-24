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
    <h2>Grafo</h2>
    <meta charset="utf-8"/>
    %= input_tag 'nodes', placeholder => '#Nodos', id => 'nodes'
    %= input_tag 'edges', placeholder => '#Edges', id => 'edges'
    %= input_tag 'start', placeholder => 'Start', id => 'start'
    %= submit_button 'Generar', id => 'render', onclick => 'renderGraph()'
    %= tag 'div', id => 'mynetwork'
    %= javascript begin
       function renderGraph() {
        // get number of nodes
    var nodes= document.getElementById("nodes");
    var g = new jsgraphs.WeightedDiGraph(nodes.value);
    // get edges info
    var pattern = document.getElementById("edges").value;
    console.log(pattern);
    var aristas = pattern.split(" ");
    console.log(aristas);
    for(let p = 0; p < aristas.length; ++p){
        let parameters = aristas[p].split("-");
        console.log(parameters);
        g.addEdge(new jsgraphs.Edge(parseInt(parameters[0]), parseInt(parameters[1]) , parseInt(parameters[2])));
    }
    var start = document.getElementById("start").value;

    var g_nodes = [];
    var g_edges = [];

    if (start.trim() === '') {
        console.log("Graph Without Dijkstra")
    } else {
        var dijkstra = new jsgraphs.Dijkstra(g, start);

        for(var v = 0; v < g.V; ++v){
            if(dijkstra.hasPathTo(v)){
                var path = dijkstra.pathTo(v);
                console.log('=====path from ' + start + ' to ' + v + ' start==========');
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
                console.log('=====path from ' + start + ' to ' + v + ' end==========');
                console.log('=====distance: '  + dijkstra.distanceTo(v) + '=========');
            }
        }
    }

    for(var v=0; v < g.V; ++v){
        g.node(v).label = 'Nodo ' + v; // assigned 'Node {v}' as label for node v
        g_nodes.push({
            id: v,
            label: g.node(v).label
        });
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

    //console.log(g.V); // display 6, which is the number of vertices in g
    //console.log(g.adj(0)); // display [5, 1, 2], which is the adjacent list to vertex 0

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