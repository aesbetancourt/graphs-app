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
    %= stylesheet 'https://fonts.googleapis.com/css?family=Press+Start+2P&display=swap'
    %= stylesheet 'https://fonts.googleapis.com/css?family=Rubik&display=swap'
    %= stylesheet begin
        body{
            background-image: url("https://images4.alphacoders.com/786/thumb-1920-786616.png");
        }
        h1, h3{
            font-family: 'Press Start 2P', cursive;
            color: #BAB3B3;
        }
        textarea {
            resize: none;
            background: transparent;
            border: none;
            width: 400px ;
            outline: none;
            color: white;
            font-size: 16px;
            height: 180px;
        }
        hr{
            height: 1px;
            background-color: #0378A6;
            border: none;
        }
        label{
            color: white;
            font-family: 'Rubik', sans-serif;
        }
        input{
            background: transparent;
            border: none;
            border-bottom: 1px solid #fff;
            height: 40px;
            outline: none;
            color: white;
            font-size: 16px;
        }
        p{
            color: white;
            font-family: 'Rubik', sans-serif;
            font-size: 12px;
        }
        #inputs{
            position: relative;
            width: 400px;
            height: 95vh;
            top: 2px;
            padding-left: 20px;
        }
        #mynetwork{
            /*border-style: solid;*/
            position: absolute;
            top: 10px;
            left: 30%;
            height: 95vh;
            width: 123vh;
        }
        #renderbtn{
            font-family: 'Press Start 2P', cursive;
            position: relative;
            margin-top: 5px;
            left: 35%;
            height: 20px;
            border: none;
            outline: none;
            border-radius: 2px;
            background-color: #0378A6;
            font-size: 10px;
            cursor: pointer;
        }
    % end
%end
  <body>
    <%= tag div => (id => 'inputs') => begin %>
        <h1>Grafos Dirigidos</h1>
        %= tag 'hr'
        <h3>Datos del Grafo</h3>
        %= form_for login => begin
            %= label_for nodes => 'Cantidad de nodos:'
            %= tag 'br'
            %= text_field 'nodes', placeholder => 'i.e: 3', id => 'nodes'
            %= tag 'br'
            %= label_for edges => 'Patrón de aristas:'
            %= tag 'br'
            %= text_field 'edges', placeholder => 'i.e: 0-1-2 1-2-3 2-0-3', id => 'edges'
            %= tag 'br'
            %= tag 'hr'
            <h3>Dijkstra</h3>
            %= label_for start => 'Nodo Inicial'
            %= tag 'br'
            %= text_field 'start', placeholder => 'Inicio', id => 'start'
        % end
        %= tag 'hr'
        %= submit_button 'Generar', id => 'renderbtn', onclick => 'renderGraph()'
        %= tag 'br'
        %= tag 'br'
        %= text_area 'dijkstra', cols => 45, rows => 10, id => 'dijkstra', placeholder => 'Cálculo del Algoritmo'
        <h3>Instrucciones</h3>
        %= tag p => begin
            Ingrese numero de nodos del grafo, luego ingrese un patrón de aristas, dicho patron funciona
            de la siguiente manera: "inicio-destino-peso inicio-destino-peso", i.e: 0-1-2 1-2-3 2-0-3.
            Para el algoritmo de Dijkstra se debe ingresar el nodo inicial, sino solo se generará el grafo.
        % end
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