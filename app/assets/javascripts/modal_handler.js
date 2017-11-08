/* Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.  */
(function($) {

  $.fn.modal_success = function(){
    this.modal('hide');

    // reset and cleanup form
    _form = this.find('form').trigger('reset');
    _form.find('input, textarea').each(function() { $(this).val('') })

    // clear error state
    this.clear_previous_errors();
  };

  $.fn.clear_previous_errors = function(){
    $('.form-group.has-error', this).each(function(){
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    });
  }

  $.fn.render_form_errors = function(data) {
    form = $('form[data-model='+data.model+']');
    form.clear_previous_errors();
    model = data.model;
    $.each(data.errors, function(field, messages){
      $input = $('[name="' + model + '[' + field + ']"]');
      $input.closest('.form-group').addClass('has-error').find('.help-block').html(messages.join(' & '));
    });
  };

}(jQuery));

$(document).ready(function() {

  $(document).bind('ajaxError', 'form', function(event, jqxhr, settings, exception){
    validatedContent = jqxhr.responseText.text().val();
    $(event.data).render_form_errors( $.parseJSON(validatedContent) );
  });
});
