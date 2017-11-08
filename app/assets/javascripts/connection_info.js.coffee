# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
$ ->
  Handlebars.registerHelper("each_except", (obj, k, opts) ->
    keys = Object.keys(obj)
    result = ''

    filter = (key) ->
      if key != k
        result = result + opts.fn('key': key, 'value': obj[key]);

    filter key for key in keys

    return result
  )

  Handlebars.registerHelper('with', (context, options) ->
    if context
      return options.fn(context)
  )

  getConnectionInfo = (e) ->
    e.preventDefault()
    btn = $(e.target)
    btnText = ""
    if $("#connection-modal").length > 0
      # Checks if the modal was already rendered.
      # Prevents multiple equal modals to be appended to the page.
      $("#connection-modal").modal()
    else
      $.ajax(
        url: btn.data("connection"),

        beforeSend: ->
          btnText = btn.text()
          btn.html("<img src='/images/ajax-loader.gif'>")
          btn.addClass('disabled')
        complete: ->
          btn.text(btnText)
          btn.removeClass('disabled')
        error: (xhr, status, err) ->
          modalTemplate = Handlebars.compile($("#connection-modal-template").html())
          modalEl = $(modalTemplate(error: err + ": " + xhr.status ))
          modalEl.appendTo('body').modal()
          modalEl.on "hidden.bs.modal", (e) ->
            modalEl.remove()
        success: (xhr) ->
          modalTemplate = Handlebars.compile($("#connection-modal-template").html())
          modalEl = $(modalTemplate(response: xhr))
          modalEl.appendTo('body').modal()

          client = new ZeroClipboard($(".btn-copy"));
          # //initializing Clipboard plugin

          client.on "copy", (e) ->
            clipboard = e.clipboardData
            $commonParent = $(e.target).closest('.input-group')
            $input =  if $commonParent.find('input').length then $commonParent.find('input') else $commonParent.find('textarea')
            clipboard.setData( "text/plain", $input.val() )

          $input = $(".modal-body").find("input[type=text]")
          $textarea = $(".modal-body").find("textarea")

          $input.on "click", (e) ->
            this.select()
          $textarea.on "click", (e) ->
            this.select()
      )

  $("body").on "click", ".js-get-connection-info", getConnectionInfo
