/* Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.  */
var DatasetTags = new function() {

  this.setAutocomplete = function() {
    $("input[name=tag]").autocomplete({
      source: function( request, response ) {
        $.ajax({
          url: "/tags/autocomplete",
          dataType: "json",
          data: {
            q: request.term
          },
          success: function( data ) {
            response( data );
          }
        });
      },
      minLength: 1,
      appendTo: ".add-tags-form"
    });
  }

  this.addTag = function(e) {
    e.preventDefault();

    if ($("input[name=tag]").val() !== "") {
      var tag_name = $("input[name=tag]").text().val().toLowerCase();
      
      if ($(".existing-classes[data-tag-name='" + tag_name + "']").length === 0 &&
      $(".new-tags").find("span[data-tag-name='" + tag_name + "']").length === 0) {

        $(".new-tags")
        .append("<span class=\"label label-default new-tag\" data-tag-name=\"" + tag_name + "\">" + tag_name + "<i class='icon icon-close-button'></i></span>");

        $("input[name=tag]").val('');
        $("input[name=tag]").focus();

        $(".new-tag").on("click", function() {
          $(this).remove();
        });
      } else {
        $("#new-tag-alert").html(tag_name + " is already associated with dataset.");
        $("#new-tag-alert").fadeIn(1000, function() {
          $("#new-tag-alert").fadeOut(3000, function(){
            $("#new-tag-alert").html("");
          })
        });
        $(".existing-classes[tag-name='" + tag_name + "']").removeClass("selected");
        $("input[name=tag]").val("");
        $("input[name=tag]").focus(	);
      }
    }
  }

  this.saveAllTagChanges = function(event) {
      var tags_to_add = [];
      var dataset_tags_to_remove = [];

      $(".existing-classes.selected").toArray().map( function(e) {
        dataset_tags_to_remove.push( $(e).attr("id") );
      });
      $(".new-tag").toArray().map(function(e) {
        tags_to_add.push( $(e).attr("data-tag-name") );
      });

      var post_data = {
        dataset_tags_to_remove: dataset_tags_to_remove,
        tags_to_add: tags_to_add
      }

      $.ajax({
        url: $('#tags-modal').data('url'),
        data: post_data,
        method: "POST",
        success: function() {
          window.location = $('#tags-modal').data('dataset-url');
        },
        error: function( e ) {
          LineaAlert("Error", "Error encountered while updating tags. <br>Please try again.", true);
        }
      });
      event.stopImmediatePropagation();
      return false;
    }

    this.loadTagCloud = function() {
      $.ajax({
        url: "/tags/popular",
        dataType: "json",
        method: "GET",
        success: function( data ) {
          var cloud = new TagCloud();
          cloud.load(data, 300, 550);
          cloud.on_tag_click_callback(function(d) {
            $("input[name=tag]").val(d.text);
          });
        }
      });
    }

}
