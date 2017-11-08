/* Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.  */
// This is a manifest file that'll be compiled into application.js, which will include all the files

// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require bootstrap-sprockets
//= require bootstrap-multiselect
//= require jquery_ujs
//= require jquery-ui/autocomplete
//= require chosen-jquery
//= require turbolinks
//= require d3
//= require handlebars
//= require zeroclipboard
//= require select2-full
//= require list
//= require_directory .

Turbolinks.enableProgressBar()

$(document).ready(function () {

    function columnHeightAdjustment() {
        var colContainer = $('.content-container');
        var leftCol = colContainer.find('> .col-md-4');
        var rightCol = colContainer.find('> .col-md-8');

        if (leftCol.outerHeight() > rightCol.outerHeight()) {
            rightCol.css('height', leftCol.outerHeight());
        }
        else {
            leftCol.css('height', rightCol.outerHeight());
        }
    }

	$(".chosen-select:visible").chosen();
	  //initializing multiselect

  $('[data-toggle="tooltip"]').tooltip().click(function(e){e.preventDefault();});

  $('.js-restrict-radios').find('input[type=radio]').change(function(e){
      //show subtext for private/managed access to dataset switch
      $(this).tab('show');
  });

  $("#error-backtrace").hide();

  $("#toggle-backtrace").click(function() {
      $("#error-backtrace").toggle(function() {
          if($('#error-backtrace').is(':visible')) {
              $("#toggle-backtrace-text").text("Hide exception details");
          } else {
              $("#toggle-backtrace-text").text("Show exception details");
          }
      });
  });

});


function LineaAlert (title, message, isError, confirmation) {

	var	alertTemplate = Handlebars.compile($("#alert-template").html()),
			alertEl = $(alertTemplate({title: title, message: message, isError: isError, confirmation: confirmation}));
			alertEl.appendTo('body').modal();

    alertEl.on("hidden.bs.modal", function (e) {
        alertEl.remove();
    });

}

$.rails.allowAction = function (link) {
    if (!link.attr('data-confirm')) return true;
    $.rails.showConfirmDialog(link);
    return false;
};
$.rails.confirmed = function (link) {
    link.removeAttr('data-confirm');
    return link.trigger('click.rails');
};


$.rails.showConfirmDialog = function(link) {
	var title = "Confirmation Required",
			message = link.attr('data-confirm');
			LineaAlert(title, message, false, true);
			return $('#alert-modal .confirm').on('click', function() {
				return $.rails.confirmed(link);
			});
};
