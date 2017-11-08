/* Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.  */
NewLineageDiagram = function(parent_lineages, child_lineages, htmlContainer, height, width, static_diagram ) {

    /* Configurations */
    var MAX_LINE_LENGTH = 19;
    var MARGIN = 70;

    /* Private attributes */
    var _color_grey = "#848484";

    /* Private attributes */
    var _width = 960;
    var _height = 800;

    var _duration = 750;

    var  _svg, _htmlContainer;
    var _static = false;

    var _child_tree, _parent_tree,_child_root, _parent_root, _child_nodes, _child_links, _parent_nodes, _parent_links;
    var _diagonal_fn, _size_scale_fn,  _text_margin_scale_fn;
    var _svg_child_tree, _svg_parent_tree;
    var _custom_node_click_callback = null,
        _custom_link_click_callback = null;


    var _back_navigation_stack = [];
    var _forward_navigation_stack = [];

    var _id = 0;

    if( static_diagram !== undefined ) {
        _static = static_diagram;
    }

    if( width !== undefined ) {
        _width = width;
    }

    if( height !== undefined ) {
        _height = height;
    }

    _width = _width - ( MARGIN * 2 );
    _height = _height - ( MARGIN * 2 );

    _htmlContainer = htmlContainer;

    _child_root = child_lineages;
    _parent_root = parent_lineages;


    /* Private functions */

    function compute_tree_layouts() {

        _parent_tree = d3.layout.tree()
                .size([_width, _height/2]);

        _parent_nodes = _parent_tree.nodes(_parent_root).reverse();
        _parent_links = _parent_tree.links(_parent_nodes);

        _child_tree = d3.layout.tree()
                .size([_width, _height/2]);

        _child_nodes = _child_tree.nodes(_child_root).reverse();
        _child_links = _child_tree.links(_child_nodes);

        // Take out root node from the child nodes since we dont want to draw it twice
        for(var i = 0; i < _child_nodes.length; i++ ) {
            if(_child_nodes[i].operation === "root") {
                _child_nodes.splice(i,1);
                break;
            }
        }

        // Loop through the child links to make sure the root node is in the correct position
        for(var i = 0; i < _child_links.length; i++ ) {
            if(_child_links[i].source.dataset_id === _parent_root.dataset_id ) {
                _child_links[i].source.x = (width - _parent_root.x) - (MARGIN*2); // remembers it rotated so translate
                _child_links[i].source.y = _parent_root.y;
            }
        }

    }

    function initialize_scale_functions() {

        var all_nodes = _parent_nodes.concat( _child_nodes );

        _size_scale_fn = d3.scale.linear().domain(d3.extent(all_nodes, function(d){ return d.size})).range([5,25]);
        _text_margin_scale_fn = d3.scale.linear().domain(d3.extent(all_nodes, function(d){ return d.size})).range([10,30]);

        _diagonal_fn = d3.svg.diagonal();

    }

    function append_name_to_node(t) {

        t.append("tspan")
            .attr("x", function(d) { return _text_margin_scale_fn(d.size); })
            .attr("dy", ".05em")
            .text(function(d) {
                var lines = split_name(d.name);
                return lines[0];
            });

        t.append("tspan")
            .attr("x", function(d) { return _text_margin_scale_fn(d.size); })
            .attr("dy", "1.05em")
            .text(function(d) {
                var lines = split_name(d.name);
                if (lines.length > 1) {
                    return lines[1] + (lines.length > 2 ? "..." : "");
                }
            });

        t.each(function(d) {
            d.bbox = this.getBBox();
        });
    }

    function split_name(name) {
        if (name == null) {
            return;
        }
        if (name.length <= MAX_LINE_LENGTH) {
            return [name];
        }
        var res = name.replace(/.{20}\S*\s+/g, "$&@").split(/\s+@/);
        return res;

    }

    function init_nodes( nodes, extra_class ) {

        extra_class = extra_class || "";
        var start_angle = (extra_class === "parent_node") ? 180 : 0;
        var modifier_angle = (extra_class === "parent_node") ? 30 : -30;

        var node_groups = nodes.enter()
                            .append("g")
                            .attr("class", function(d) {
                                var classes = extra_class + " node";
                                if( d.operation === "root" ) {
                                    classes = classes + " root";
                                }else if(d.children !== undefined && d.children !== null) {
                                    classes = classes + " expandable";
                                }
                                return classes;
                            })
                            .attr("transform", function(d) {
                                var angle = start_angle;
                                if( d.parent !== undefined && d.parent.children !== null && d.parent.children.length > 1 ) {
                                    angle = angle + modifier_angle;
                                }
                                return "translate(" + d.x + "," + d.y +") rotate(" + angle + ")";
                            })
                            .style("opacity", 0);

        nodes.exit()
            .transition()
            .duration(_duration)
            .style("opacity", 0);

        nodes.transition()
            .duration(_duration)
            .attr("transform", function(d) {
                var angle = start_angle;
                if( d.parent !== undefined && d.parent.children !== null && d.parent.children.length > 1 ) {
                    angle = angle + modifier_angle;
                }
                return "translate(" + d.x + "," + d.y +") rotate(" + angle + ")";
            })
            .style("opacity", 1);

        node_groups.append("circle").attr("r", function(d) { return _size_scale_fn(d.size); } );

        var node_texts = node_groups.append("text")
            .attr("text-anchor", "start");

        append_name_to_node(node_texts);
    }

    function init_links( links, extra_class ) {

        extra_class = extra_class || "";

        links.enter()
                .append("path")
                .attr("class",function(d) { return extra_class + " link"; } )
                .attr("d", function(d) { return _diagonal_fn(d); } )
                .style("opacity", 0);

        links.transition()
                        .duration(_duration)
                        .attr("d", function(d) { return _diagonal_fn(d); } )
                        .style("opacity", "1");

        links.exit().transition()
                        .duration(_duration)
                        .attr("d", function (d) {
                            return _diagonal_fn(d);
                        })
                        .style("opacity", "0");
    }

    function draw() {

        var svg_parent_links = _svg_parent_tree.selectAll("path.parent_link")
                                    .data( _parent_links, function (d) {
                                        return d.target.lineage_id;
                                    });

        init_links( svg_parent_links, "parent_link" );


        var svg_child_links = _svg_child_tree.selectAll("path.child_link")
                                    .data( _child_links, function (d) {
                                       return d.target.lineage_id;
                                    });

        init_links( svg_child_links, "child_link" );


        var svg_parent_nodes = _svg_parent_tree.selectAll("g.parent_node")
                                    .data( _parent_nodes, function(d) { return d.id || (d.id = ++_id); } );


        init_nodes( svg_parent_nodes, "parent_node");


        var svg_child_nodes = _svg_child_tree.selectAll("g.child_node")
                                    .data( _child_nodes, function(d) { return d.id || (d.id = ++_id); } );

        init_nodes( svg_child_nodes, "child_node");

        // Assign interactive callback actions
        _svg.selectAll( "g.expandable" ).on("click.interactive", function(d){
            toggle(d);
        });

        _svg.selectAll( "g.node" ).on("mouseover.interactive", function(d){

            if( d3.select(this).style("opacity") !== 0 ) {
                var text_bbox;
                var element = d3.select(this);

                element = element.append("g")
                            .attr("class", "size-popup");
                element.append("svg:rect");
                element.append("svg:text");

                element.select("text")
                    .attr("class", "size-popup");

                element.select("text").append("tspan")
                    .attr("x", 5)
                    .attr("dy", ".05em")
                    .text(function(d) {
                        return "Size: " + d.size_formatted;
                    });

                element.select("text").append("tspan")
                    .attr("x", 5)
                    .attr("dy", "1.05em")
                    .text(function(d) {
                       return "Owner: " + d.owner;
                    });

                element.select("text").append("tspan")
                    .attr("x", 5)
                    .attr("dy", "1.05em")
                    .text(function(d) {
                       return "Datasource: " + d.datasource;
                    });

                element.select("text").attr("y", function(d) { return 30; });

                element.select("text").each(function(d) {
                        text_bbox = this.getBBox();
                    });

                element.select("rect")
                    .attr("x", function(d) { return text_bbox.x - 5; })
                    .attr("y", function(d) { return text_bbox.y - 5; })
                    .attr("width", function(d) { return text_bbox.width + 10; })
                    .attr("height", function(d) { return text_bbox.height + 10; })
                    .attr("fill-opacity", 0.9)
                    .attr("rx", 10);
            }
        });

        _svg.selectAll( "g.node" ).on("mouseout.interactive", function(d){
            d3.select(this).select(".size-popup").remove();
        });
    }

    function collapse(d) {
        if (d.children) {
            d._children = d.children;
            d._children.forEach(collapse);
        }
        d.children = null;
    }

    // Toggle children on click.
    function toggle(d) {
        if (d.children) {
            d._children = d.children;
        } else {
            d.children = d._children;
        }
        d._children = null;
        compute_tree_layouts();
        draw();
    }

    function enable_interactivity() {
        _svg.selectAll( "g.node" ).on("dblclick.interactive", function(d) {
           reroot( d.dataset_id );
        });

        _svg.selectAll( "g.node" ).on("click.custom", _custom_node_click_callback);

        _svg.selectAll( "path.link" ).on("click.custom", _custom_link_click_callback);
    }

    function reroot( dataset_id, dont_push_on_stack) {

        if( dataset_id !== _child_root.dataset_id) {
            if( !dont_push_on_stack ) {
                _back_navigation_stack.push( _child_root.dataset_id );
            }

            $.ajax({
                url: "/datasets/" + dataset_id + "/explore_lineage",
                method: "GET",
                success: function(response) {
                    _child_root = response.child_lineages;
                    _parent_root = response.parent_lineages;

                    compute_tree_layouts(); //TODO: Fix so we wont have to call compute_tree_layouts twice
                    initialize_scale_functions();
                    draw(); //TODO: Fix so we wont have to call draw twice

                    if( _child_root.children !== undefined && _child_root.children.forEach !== undefined ) {
                        _child_root.children.forEach(collapse);
                    }
                    if( _parent_root.children !== undefined && _parent_root.children.forEach !== undefined ) {
                        _parent_root.children.forEach(collapse);
                    }

                    compute_tree_layouts();
                    draw();
                    enable_interactivity();

                    update_buttons();

                }
            });

        }
    }

    function reroot_back() {
        if( _back_navigation_stack.length > 0 ) {
            var dataset_id = _back_navigation_stack.pop();
            _forward_navigation_stack.push( _child_root.dataset_id );

            reroot( dataset_id, true );
        }
    }

    function reroot_forward() {

        if( _forward_navigation_stack.length > 0 ) {
            var dataset_id = _forward_navigation_stack.pop();
            _back_navigation_stack.push( _child_root.dataset_id );

            reroot( dataset_id, true);
        }

    }

    var _home_dataset_id, _home_button, _back_button, _forward_button, _reroot_button, _reroot_button_dataset_id = null;
    function set_home_button( button ) {
        _home_dataset_id = _child_root.dataset_id;
        _home_button = button;
        button.on("click", function() {
            reroot( _home_dataset_id );
        });
    }

    function set_back_button( button ) {
        _back_button = button;
        button.on("click", reroot_back );
        update_buttons();
    }

    function set_forward_button( button ) {
        _forward_button = button;
        button.on("click", reroot_forward );
        update_buttons();
    }

    function set_reroot_button( button, dataset_id ) {
        _reroot_button = button;
        _reroot_button_dataset_id = dataset_id;
        button.on("click", function() {
            reroot( _reroot_button_dataset_id );
        });
        update_buttons();
    }

    function update_buttons() {
        if( _back_navigation_stack.length === 0 && _back_button ) {
            _back_button.attr("disabled", "disabled");
        }else if( _back_button ) {
            _back_button.removeAttr("disabled");
        }
        if( _forward_navigation_stack.length === 0 && _forward_button ) {
            _forward_button.attr("disabled", "disabled");
        }else if( _forward_button ) {
            _forward_button.removeAttr("disabled");
        }
        if( _home_dataset_id === _child_root.dataset_id ) {
            _home_button.attr("disabled", "disabled");
        }else{
            _home_button.removeAttr("disabled");
        }
        if( _reroot_button_dataset_id === _child_root.dataset_id && _reroot_button !== undefined ) {
            _reroot_button.css("display", "none");
        }else if(  _reroot_button !== undefined ){
            _reroot_button.css("display", "");
        }
    }

    return {
        load: function( ){
            _svg = d3.select( _htmlContainer ).append("svg")
                .attr("width", _width + (MARGIN * 2))
                .attr("height", _height + (MARGIN * 2));

            if( _child_root.children === undefined && _parent_root.children === undefined ) {
                _svg.append("svg:text")
                    .text("No data available.")
                    .attr("x", 100 )
                    .attr("y", _height / 2 )
                    .attr("fill", _color_grey);
            }else{

                compute_tree_layouts();
                initialize_scale_functions();

                // Initialize SVG
                if( _static ) {
                    var offset_x = ( _parent_root.children !== undefined ) ? (_height/2) : 0;
                    _svg_child_tree = _svg.append("g").attr("transform", "translate( 0,"+(offset_x + MARGIN)+")");
                    _svg_parent_tree = _svg.append("g").attr("transform", "translate("+ _width + "," + (offset_x + MARGIN) + ") rotate(180)");

                    if( _parent_root.children === undefined || _child_root.children === undefined ) {
                        _svg.attr("height", (_height/2 + (MARGIN * 2)));
                    }
                }else{
                    _svg_child_tree = _svg.append("g").attr("transform", "translate( 0,"+(_height/2 + MARGIN)+")");
                    _svg_parent_tree = _svg.append("g").attr("transform", "translate("+ _width + "," + (_height/2 + MARGIN) + ") rotate(180)");
                }

                draw();

                if( _child_root.children !== undefined && _child_root.children.forEach !== undefined ) {
                    _child_root.children.forEach(collapse);
                }
                if( _parent_root.children !== undefined && _parent_root.children.forEach !== undefined ) {
                    _parent_root.children.forEach(collapse);
                }

                compute_tree_layouts();
                draw();
            }
        },
        node_click_callback: function( callback ) {
            _custom_node_click_callback = callback;
        },
        link_click_callback: function( callback ) {
            _custom_link_click_callback = callback;
        },
        enable_interactivity: enable_interactivity,
        reroot: reroot,
        set_home_button: set_home_button,
        set_back_button: set_back_button,
        set_forward_button: set_forward_button,
        set_reroot_button: set_reroot_button
    };
};