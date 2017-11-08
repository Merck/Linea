/* Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.  */
$(function() {
  var RemoveDatasets = {
    remove_dataset_button: '.remove-dataset-btn',
    remove_dataset_dialog: '.dialog',
    remove_dataset_dialog_inner: '.dialog .inner',
    remove_dataset_dialog_initial: '.dialog .initial',
    cancel_action_link: '.dialog .cancel-action',
    continue_action_button: '.dialog .continue-action',
    remove_action_button: '.dialog .remove-action',

    initialize: function() {
      $(document).off('.remove_dataset').on('click.remove_dataset', this.remove_dataset_button,
        this.show_dialog.bind(this));

      $(document).off('.cancel_action').on('click.cancel_action', this.cancel_action_link,
        this.hide_dialog.bind(this));

      $(document).off('.continue_action').on('click.continue_action', this.continue_action_button,
        this.check_on_dataset_status.bind(this));

      $(document).off('.remove_action').on('click.remove_action', this.remove_action_button,
        this.remove_dataset.bind(this));
    },

    show_dialog: function() {
      if ($(this.remove_dataset_dialog_initial).length == 1) {
        $(this.remove_dataset_dialog).show();
      } else {
        this.render_initial_scenario();
        $(this.remove_dataset_dialog).show();
      }
    },

    render_initial_scenario: function() {
      var remove_dataset_dialog_inner = $(this.remove_dataset_dialog_inner);

      $.ajax({
        method: 'GET',
        url: $(this.remove_dataset_dialog).data('action'),
        cache: false,
        async: false,
        success: function(data) {
          remove_dataset_dialog_inner.html(data);
        }
      })
    },

    hide_dialog: function() {
      $(this.remove_dataset_dialog).hide();
    },

    check_on_dataset_status: function() {
      var continue_action_button = $(this.continue_action_button);
      var remove_dataset_dialog_inner = $(this.remove_dataset_dialog_inner);

      $.ajax({
        method: 'GET',
        url: continue_action_button.data('action'),
        cache: false,
        beforeSend: function() {
          continue_action_button
            .find('div:first-child')
              .show()
            .end()
            .find('div:last-child')
              .css('margin-left', '40px')
            .end()
              .css('width', '133px')
              .parents('.actions').css('width', '210px');
        },

        success: function(data) {
          remove_dataset_dialog_inner.html(data);
        },

        complete: function() {
          continue_action_button
            .find('div:first-child').hide()
            .end()
            .find('div:last-child').css('margin-left', '9px')
            .end()
              .css('width', '100px');
        }
      })
    },

    remove_dataset: function(event) {
      var remove_action_button = $(this.remove_action_button);
      var redirect_to = remove_action_button.data('redirect-to');

      $.ajax({
        method: 'POST',
        data: {'_method': 'delete'},
        url: remove_action_button.data('action'),
        cache: false,

        beforeSend: function() {
          remove_action_button
            .find('div:first-child')
              .show()
            .end()
            .find('div:last-child')
              .css('margin-left', '40px')
            .end()
              .css('width', '133px')
              .parents('.actions').css('width', '210px');
        },

        error: function() {
          window.location.replace(redirect_to);
        }
      }).done(function() {
          window.location.replace(redirect_to);
      })
    }
  }

  RemoveDatasets.initialize();

});
