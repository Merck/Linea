/* Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.  */
TagCloud = function() {

	var _width = 300;
	var _height = 300;
	var text_scale;

	var fill = function(i) {
		colors = ["#2980C3", "#4D4D4D", "#4D4D4D", "#848484", "#4D4D4D", "#EBD246"];
		return colors[i%colors.length];
	}

	function draw(words) {
    // do not append another tagcloud, if some already exists here
		if ($('#tag-cloud svg').length !== 0) { return }
		d3.select("#tag-cloud").append("svg")
	        .attr("width", _width)
	        .attr("height", _height)
	      .append("g")
	        .attr("transform", "translate(" + _width/2 +","+ _height/2 + ")")
	      .selectAll("text")
	        .data(words)
	      .enter().append("text")
	        .style("font-size", function(d) { return d.size+"px"; })
	        .style("fill", function(d, i) { return fill(i); })
	       // .style("text-transform", "capitalize")
	        .attr("text-anchor", "middle")
	        .attr("transform", function(d) {
	          return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
	        })
	        .text(function(d) { return d.text; });
	  }

	return {
		load: function(data, height, width){

			if( width !== undefined ) {
				_width = width;
			}
			if( height !== undefined ) {
				_height = height;
			}

			text_scale = d3.scale.linear().domain(d3.extent(data, function(d) { return d.size; })).range([16,36]);

			d3.layout.cloud().size([_width, _height])
		      .words(data)
		      .padding(5)
		      .rotate(function() { return ~~(Math.random() * 2) * 90; })
		      .fontSize(function(d) {return text_scale(d.size); })
		      .on("end", draw)
		      .start();
		},
		on_tag_click_callback: function( callback ) {
			d3.select("#tag-cloud").selectAll("text").on("click", callback);
		}
	}

};
