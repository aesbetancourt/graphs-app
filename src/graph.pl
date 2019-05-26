use strict;
use warnings FATAL => 'all';
use Mojolicious::Lite;

get '/' => 'index';

app->start;
__DATA__

@@ index.html.ep
<html lang="es">
%= t head => begin
    %= t meta => charset => 'utf-8'
    %= t title => 'Algoritmo de Dijkstra'
    %= javascript 'https://rawgit.com/chen0040/js-graph-algorithms/master/third-party-libs/vis/vis.js'
    %= javascript 'https://rawgit.com/chen0040/js-graph-algorithms/master/src/jsgraphs.js'
    %= stylesheet 'https://rawgit.com/chen0040/js-graph-algorithms/master/third-party-libs/vis/vis.css'
    %= stylesheet begin
        textarea {
            resize: none;
        }
        #inputs{
            position: relative;
            width: 400px;
            border-style: solid;
            height: 95vh;
            top: 2px;
            padding-left: 20px;
        }
        #mynetwork{
            border-style: solid;
            position: absolute;
            top: 10px;
            left: 30%;
            height: 95vh;
            width: 123vh;
        }
    % end
%end
  <body>
    <%= tag div => (id => 'inputs') => begin %>
        <h1>Grafos dirigidos</h1>
        %= input_tag 'nodes', placeholder => '#Nodo', id => 'nodes'
        %= input_tag 'edges', placeholder => '#Edges', id => 'edges'
        %= input_tag 'start', placeholder => 'Start', id => 'start'
        %= submit_button 'Generar', id => 'render', onclick => 'renderGraph()'
        %= tag 'br'
        %= text_area 'dijkstra', cols => 40, rows => 20, id => 'dijkstra'
    <% end %>
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

    var values = '';
    if (start.trim() === '') {
        document.getElementById("dijkstra").value = "Graph Without Dijkstra";
    } else {
        var dijkstra = new jsgraphs.Dijkstra(g, start);

        for(var v = 0; v < g.V; ++v){
            if(dijkstra.hasPathTo(v)){
                var path = dijkstra.pathTo(v);
                values += ('=====Ruta desde ' + start + ' hasta ' + v +'\n');
                for(var i = 0; i < path.length; ++i) {
                    var e = path[i];
                    values += (e.from() + ' => ' + e.to() + ': ' + e.weight + '\n');
                    g_edges.push({
                        from: e.from(),
                        to: e.to(),
                        length: e.weight,
                        label: '' + e.weight,
                        arrows:'to',
                        color: '#00ff00'
                    });
                }
                    //values += ('=====path from ' + start + ' to ' + v + ' end==========');
                    values += ('=====Distancia: '  + dijkstra.distanceTo(v) + '=========\n');
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
    if (values === ''){
        values = 'Nodo inicial no especificado. Dijkstra no calculado';
    }
    document.getElementById("dijkstra").value = values;
    }
    % end
</body>
</html>