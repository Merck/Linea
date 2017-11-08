/* Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.  */
LineageDiagram = function(linages, htmlContainer, height, width, upside_down ) {

    /* Configurations */
    var MAX_LINE_LENGTH = 19;
    var MARGIN = {top: 20, right: 120, bottom: 20, left: 120};

    /* Private attributes */
    var _color_grey = "#848484";

    /* Private attributes */
    var _width = 960;
    var _height = 800;
    var _i = 0;
    var _duration = 750;
    var _upside_down = false;

    var _tree, _diagonal, _svg, _htmlContainer, _root, _text_margin_scale;

    if( width !== undefined ) {
        _width = width;
    }

    if( height !== undefined ) {
        _height = height;
    }

    if( upside_down !== undefined ) {
        _upside_down = upside_down;
    }

    _width = _width - MARGIN.right - MARGIN.left;
    _height = _height - MARGIN.top - MARGIN.bottom;

    _htmlContainer = htmlContainer;

    _root = linages;

    /* Private functions */

    // @params t: the text element
    function appendName(t) {

        t.append("tspan")
            .attr("x", function(d) { return _text_margin_scale(d.size); })
            .attr("dy", ".05em")
            .text(function(d) {
                var lines = splitName(d.name);
                return lines[0];
            });

        t.append("tspan")
            .attr("x", function(d) { return _text_margin_scale(d.size); })
            .attr("dy", "1.05em")
            .text(function(d) {
                var lines = splitName(d.name);
                if (lines.length > 1) {
                    return lines[1] + (lines.length > 2 ? "..." : "");
                }
            });

        t.each(function(d) {
            d.bbox = this.getBBox();
        });
    }

    function splitName(name) {
        if (name == null) {
            return;
        }
        if (name.length <= MAX_LINE_LENGTH) {
            return [name];
        }
        var res = name.replace(/.{20}\S*\s+/g, "$&@").split(/\s+@/);
        return res;

    }

    function update(source) {

        // Compute the new tree layout.
        var nodes = tree.nodes(_root).reverse(),
            links = tree.links(nodes);

        var max_size = 0;
        var min_size = Infinity;

        // Normalize for fixed-depth.
        nodes.forEach(function (d) {
            d.y = d.depth * (_height / 3);
            if( d.size > max_size) { max_size = d.size; }
            if( d.size < min_size) { min_size = d.size; }
        });

        // Create linear size scale
        var size_scale = d3.scale.linear().domain([min_size, max_size]).range([5,20]);
        _text_margin_scale = d3.scale.linear().domain([min_size, max_size]).range([10,25]);

        if( _upside_down ) {
            nodes.forEach(function (d) {
                d.y = height - d.y - MARGIN.top - 30;
            });
        }

        // Update the nodes…
        var node = _svg.selectAll("g.node")
            .data(nodes, function (d) {
                return d.id || (d.id = ++_i);
            });

        // Enter any new nodes at the parent's previous position.
        var nodeEnter = node.enter().append("g")
            .attr("class", "node")
            .attr("transform", function (d) {
                var rotation = ( d.parent !== undefined && d.parent.children.length !== 1 ) ? 30 : 0; // Rotate if you have siblings
                return "translate(" + source.x0 + "," + source.y0 + ") rotate(" + rotation + ")";
            })
            .on("click", click);

        nodeEnter.append("svg:circle")
            .attr("class", function (d) {
                return d._children ? "has-children" : "";
            })
            .attr("r", function(d) { return size_scale(d.size); })

        var t = nodeEnter.append("text")
            .attr("dx", 0)
            .attr("style", function(d) { return "font-size: 12px;"; } )
            .attr("text-anchor", "start")
            .style("fill-opacity", 1e-6);

        // Append the node name.
        // Will break it into 2 lines if greater than MAX_LINE_LENGTH chars.
        // Will truncate after line 2 using "..." if 3+ lines.
        appendName(t);

        nodeEnter.on("mouseover", function(d){

            var text_bbox;
            var element = d3.select(this);

            element = element.append("g")
                        .attr("class", "size-popup");
            element.append("svg:rect");
            element.append("svg:text");

            element.select("text")
                .attr("class", "size-popup")
                .attr("dy", -(_text_margin_scale(d.size)) - 5 )
                .text("Size: " + d.size + " bytes")
                .each(function(d) {
                    text_bbox = this.getBBox();
                });

            element.select("rect")
                .attr("x", function(d) { return text_bbox.x - 5; })
                .attr("y", function(d) { return text_bbox.y - 5; })
                .attr("width", function(d) { return text_bbox.width + 10; })
                .attr("height", function(d) { return text_bbox.height + 10; })
                .attr("rx", 10);
        });

        nodeEnter.on("mouseout", function(d){
            d3.select(this).select(".size-popup").remove();
        });

        // Transition nodes to their new position.
        var nodeUpdate = node.transition()
            .duration(_duration)
            .attr("transform", function (d) {
                var rotation = ( d.parent !== undefined && d.parent.children.length !== 1 ) ? 30 : 0; // Rotate if you have siblings
                return "translate(" + d.x + "," + d.y + ") rotate(" + rotation + ")";
            });

        nodeUpdate.select("circle")
            .style("fill-opacity", 1);

        nodeUpdate.select("text")
            .style("fill-opacity", 1);

        // Transition exiting nodes to the parent's new position.
        var nodeExit = node.exit().transition()
            .duration(_duration)
            .attr("transform", function (d) {
                var rotation = 0;
                return "translate(" + source.x + "," + source.y + ") rotate(" + rotation + ")";
            })
            .remove();

        nodeExit.select("circle")
            .style("fill-opacity", 1e-6);

        nodeExit.select("text")
            .style("fill-opacity", 1e-6);

        // Update the links…
        var link = _svg.selectAll("path.link")
            .data(links, function (d) {
                return d.target.id;
            });

        // Enter any new links at the parent's previous position.
        link.enter().insert("path", "g")
            .attr("id", function(d) { return "link-" + d.target.lineage_id; })
            .attr("class", "link")
            .attr("d", function (d) {
                var o = {x: source.x0, y: source.y0};
                return diagonal({source: o, target: o});
            });

        // Transition links to their new position.
        link.transition()
            .duration(_duration)
            .attr("d", diagonal);

        // Transition exiting nodes to the parent's new position.
        link.exit().transition()
            .duration(_duration)
            .attr("d", function (d) {
                var o = {x: source.x, y: source.y};
                return diagonal({source: o, target: o});
            })
            .remove();

        // Stash the old positions for transition.
        nodes.forEach(function (d) {
            d.x0 = d.x;
            d.y0 = d.y;
        });
    }

    // Toggle children on click.
    function click(d) {
        if (d.children) {
            d._children = d.children;
        } else {
            d.children = d._children;
        }
        d.children = null;
        update(d);
    }

    return {
        load: function( ){

            tree = d3.layout.tree()
                .size([_width, _height]);

            diagonal = d3.svg.diagonal()
                .projection(function (d) {
                    return [d.x, d.y];
                });

            _svg = d3.select( _htmlContainer ).append("svg")
                .attr("width", _width + MARGIN.right + MARGIN.left)
                .attr("height", _height + MARGIN.top + MARGIN.bottom)
                .append("g")
                .attr("transform", "translate(" + MARGIN.left + ", " + MARGIN.top + ")");

            _root.x0 = width / 2;
            _root.y0 = 0;

            function collapse(d) {
                if (d.children) {
                    d._children = d.children;
                    d._children.forEach(collapse);
                    d.children = null;
                }
            }

            if( _root.children === undefined ) {
                _svg.append("svg:text")
                    .text("No data available.")
                    .attr("x", 100 )
                    .attr("y", _height / 2 )
                    .attr("fill", _color_grey);

            }else{

                _root.children.forEach(collapse);
                update(_root);

            }
        },
        node_click_callback: function( callback ) {
            _svg.selectAll( "g.node" ).on("click", callback);
        },
        node_doubleclick_callback: function( callback ) {
            _svg.selectAll( "g.node" ).on("dblclick", callback);
        },
        link_click_callback: function( callback ) {
            _svg.selectAll( "path.link" ).on("click", callback);
        }
    };
};