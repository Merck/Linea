/* Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.  */
/* This class is used to generate the SVG used for relationship diagrams */
SharedColumnsDiagram = function( datasets, columns, relations, height, width ) {


	/* Configuration parameters */
	var LINE_BOUNCE_A = 30;
	var LINE_BOUNCE_B = 40;
	var DATASET_LINK = "/datasets/";

	/* Private attributes */
	var _color_grey = "#848484";
  	var _color_blue = "#2980C3";
  	var _color_charcoal = "#4D4D4D";
  	var _color_red = "#800000";

  	var _datasets = datasets;
  	var _columns = columns;
  	var _relations = relations;

	var _width = (width === undefined) ? 700 : width;
	var _height = (height === undefined) ? 600 : height;

    var _rx = _width - 200;
    var _ry = (_height / 2);

    var _svg;

    var _column_svg_groups;
    var _dataset_svg_groups;


    /* Private functions */

    function draw_columns() {

		_column_svg_groups = _svg.append("svg:g")
		            .attr("class","shared_columns")
		            .selectAll("text")
		            .data(_columns)
		            .enter().append("svg:g")
		              .attr("id", function(d) { return "shared-column-" + d.id; } )
		              .attr("fill","white")
		              .on('mouseover', on_mouseover_column)
		              .on('mouseout', on_mouseout_column);

		_column_svg_groups.append("svg:rect")
		            .attr("fill", _color_blue)
		            .attr("width", "200" )
		            .attr("height", "18" )
		            .attr("rx", "2" )
		            .attr("ry", "2" );

		_column_svg_groups.append("svg:text")
		            .attr("dy", 13)
		            .attr("dx", 5)
		            .text(function(d) { return d.name; })
		            .each(function(d) {
		              d.text_bbox = this.getBBox();
		              d.element = this;
		              d.width = this.getBBox().width;
		            });

		_column_svg_groups.attr("transform", function(d, i) {
			d.x = 0;
			d.y = (i * 20) - (_ry/2);

			d.line_x = d.x;
			d.line_y = d.y + 9;

			return "translate(" + d.x + "," + d.y + ")";
		});

    }


    function draw_datasets() {
		_dataset_svg_groups  = _svg.append("svg:g")
		            .attr("class","nodes")
		            .selectAll("text")
		            .data(_datasets)
		          .enter().append("svg:g")
		            .attr("id", function(d) { return "dataset-" + d.id; } )
		            .attr("fill", _color_blue)
		            .attr("cursor", "pointer")
		            .on('mouseover', on_mouseover_dataset)
		            .on('mouseout', on_mouseout_dataset)
		            .on('click', on_click_dataset);

		_dataset_svg_groups.append("svg:text")
		          .text(function(d) { return d.name; })
		          .attr("text-anchor", "end")
		          .each(function(d) {
		              d.text_bbox = this.getBBox();
		              d.width = this.getBBox().width;
		            });

		_dataset_svg_groups.append("circle")
		          .attr("cx", function(d) {
		            d.circle_x = 10;
		            return d.circle_x;
		          })
		          .attr("cy", function(d) {
		            d.circle_y = -5;
		            return d.circle_y;
		          })
		          .attr("r", 5);

		var radians_offset = Math.PI/8;
		var radians = Math.PI - ( radians_offset );
		var radians_per_entry = radians / _dataset_svg_groups.size();
		var radius = 200;

		_dataset_svg_groups.attr("transform", function(d, i) {

			var rotation_radians = (radians_per_entry * i) + radians_offset;

			d.x = Math.sin( rotation_radians ) * -radius;
			d.y = Math.cos( rotation_radians ) * -radius;

			d.line_x = d.circle_x + d.x;
			d.line_y = d.y - 5;

			return "translate(" + d.x + "," + d.y + ")";
		});

		// Next check that all labels are visible and wont overflow the width of the SVG.
		// If any of the bbox's overflows split name into lines of 25 characters each.
		// If more than two lines add "..." to second line and throw away the rest.
		_dataset_svg_groups.each(function(d) {

			if( (d.x + _rx) < Math.abs(d.text_bbox.width) ) {

				var name_lines = d.name.replace(/.{25}\S*\s+/g, "$&@").split(/\s+@/);
				if( name_lines.length > 2) {
					name_lines[1] += "...";
				}

				var text_element = d3.select(this).select("text");
				text_element.text("");
				text_element.append("tspan")
					.attr("x", 0)
		            .attr("dy", ".05em")
		            .text(function(d) {
		                return name_lines[0];
		            });
		        text_element.append("tspan")
		            .attr("x", 0)
		            .attr("dy", "1.05em")
		            .text(function(d) {
	                    return name_lines[1];
		            });

				d.text_bbox = this.getBBox();

			}
		});

    }

    function draw_relations() {

		var link = _svg.selectAll(".link")
		.data(_relations)
		.enter().append("path")
			.attr("d", generate_bezier_curve_from_relation)
			.attr("class", function(d) { return "dataset-link-" + d.source + " business-key-link-" + d.target; } )
			.attr("stroke", _color_grey)
			.attr("stroke-width", "1")
			.attr("fill", "transparent");

    }

    function generate_bezier_curve_from_relation( relation )
	{
		var source, target;
		_dataset_svg_groups.each(function(n) {
		  if( n.id === relation.source ) {
		    source = n;
		  }
		});
		_column_svg_groups.each(function(n) {
		  if( n.id === relation.target ) {
		    target = n;
		  }
		});
		return "M" + (source.line_x) + " " + (source.line_y) + " C " + (source.line_x+LINE_BOUNCE_A) + " " + (source.line_y) + ", " + (target.line_x-LINE_BOUNCE_A)  + " " + (target.line_y-LINE_BOUNCE_B) + ", " + target.line_x  + " " + (target.line_y);
	}


	function on_mouseover_dataset( d ) {
		d3.select(this).attr("fill", _color_charcoal);
		d3.selectAll(".dataset-link-" + d.id ).attr("stroke", _color_charcoal);
		d3.selectAll(d.relations).each(function(){
			d3.select("#shared-column-" + this ).select("rect").attr("fill", _color_charcoal);
		});
	  }

	function on_mouseout_dataset( d ) {
		d3.select(this).attr("fill", _color_blue );
		d3.selectAll(".dataset-link-" + d.id ).attr("stroke", _color_grey );
		d3.selectAll(d.relations).each(function(){
			d3.select("#shared-column-" + this ).select("rect").attr("fill", _color_blue);
		});
	}

	function on_click_dataset( d ) {
		window.location = DATASET_LINK + d.id;
	}

	function on_mouseover_column( b ) {
		d3.select(this).select("rect").attr("fill", _color_red );
		d3.selectAll(".business-key-link-" + b.id ).attr("stroke", _color_red);
		d3.selectAll(b.relations).each(function(){
			d3.select("#dataset-" + this).attr("fill", _color_red);
		});
	}

	function on_mouseout_column( b ) {
		d3.select(this).select("rect").attr("fill", _color_blue );
		d3.selectAll(".business-key-link-" + b.id ).attr("stroke", _color_grey);
		d3.selectAll(b.relations).each(function(){
  			d3.select("#dataset-" + this).attr("fill", _color_blue);
		});
	}


    return {

    	/* Public functions */
    	load : function() {

    		_svg = d3.select("#relationship-diagram").append("svg:svg");

			if( _columns.length == 0 ) {
				_svg.attr("width", _width)
                    .attr("height", 100)
                    .append("svg:text")
					.text("This dataset does not have any shared columns.")
					.attr("y", 50)
					.attr("style","font-size: 14px;");
			}else{

				_svg = _svg.attr("width", _width)
                           .attr("height", _height)
                           .append("svg:g")
			    	       .attr("transform", "translate(" + _rx + "," + _ry + ")");

				draw_columns();

				draw_datasets();

				draw_relations();
			}


			return _svg;
    	}

    };

};