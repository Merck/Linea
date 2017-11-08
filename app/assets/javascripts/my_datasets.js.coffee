# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
$ ->
  schema = $('#schema')
  datasetCol = $('#describe-dataset')
  transformationCol = $('#describe-transformation')

  tablesContainer = $("#tables-container")
  subjectAreaSelect = $("select[id$='dataset_subject_area_id']")

  startUniqRecIds = new Date().getTime()
  uniqRecId = -> startUniqRecIds++

  templates = -> {
    tableFields: Handlebars.compile($("#table-fields-template").html())
    columnFields: Handlebars.compile($("#column-fields-template").html())
  }

  ##show correct tab if linked from outside with a hash
  if $('.js-hash-links').length
    hash = document.location.hash;
    prefix = "tab-";
    if hash
      $('.js-hash-links[href='+hash.replace(prefix,"")+']').tab('show')

    # Change hash for page-reload
    $('.js-hash-links').on 'shown.bs.tab',  (e) ->
      window.location.hash = e.target.hash.replace("#", "#" + prefix)

  ##properly load tags field on tab change

  $(".chosen-select:visible").chosen()

  $('.js-toggle-dataset-forms').on 'shown.bs.tab', (e) ->
    activeTab = $(e.target).attr('href')
    $(activeTab).find(".chosen-select").chosen({width: "100%"})
    adjustColumns()

  ## Equal outerHeight of datatset and transformation columns

  adjustColumns = ->
    if datasetCol.first().outerHeight() > transformationCol.first().outerHeight()
      transformationCol.first().css("min-height", datasetCol.first().outerHeight() + "px")
    else
      datasetCol.first().css("min-height", transformationCol.first().outerHeight() + "px")

  if datasetCol.length and transformationCol.length
    adjustColumns()

  ## Equal outerHeight of datatset and transformation columns ends

  ## Set default subject area to 'None' only on for new datasets

  if $('.new-dataset').length && subjectAreaSelect.length
    defaultValue = 11 # id for 'None' subject area options
    subjectAreaSelect.each ->
      # find default value option, make it first in the list and select it
      defaultOption = $(this).find('option[value=' + defaultValue + ']')
      $(this).prepend(defaultOption)
      $(this).val(defaultValue)

  ## Delta queries validation and error handling

  class DeltaQuery
    constructor: ($field) ->
      @field = $field
      @uploadForm = @field.closest('form')
      @errorMsg = 'Please, check your syntax.' +
                '<br>Each query should start with "select" keyword and be separated with a semicolon.'
      @isValid = ->
        input = @field.val()
        arr = input.split(';')
        result = true

        validate = (str) ->
          empty = /^\s*$/.test(str)
          correctQuery = /^(?!.*\bselect\b.*\bselect\b)\s*\bselect\b/i.test(str)
          #Checks if the line has only one select and it is in the beggining
          #of the line. Extra spacing at the start of the line is allowed
          correctQuery or empty

        i = 0
        len = arr.length
        while i < len
          #Validate all queries. If any of them fails, stop and retutn false
          if !validate(arr[i])
            result = false
            break
          i++
        result
      @showErrors = ->
        @field.parent().find('.help-block').remove()
        @field.parent().addClass('has-error').append '<span class=\'help-block\'>' + @errorMsg + '</span>'
        @uploadForm.find('[type=submit]').addClass('disabled')
        return
      @clearErrors = ->
        @field.parent().find('.help-block').remove()
        @field.parent().removeClass('has-error').addClass('has-success').delay(3000).queue ->
          $(this).removeClass('has-success')
          return
        @uploadForm.find('[type=submit]').removeClass('disabled')
        validateAllQueries()
        return
      @init = ->
        self = @
        @field.change (e) ->
          if !self.isValid()
            self.showErrors()
          else
            self.clearErrors()
          return
        return

  if $('[data-form=custom-query]').length > 0
    queries = []
    addQueryListeners = ->
      queryFields = $('[data-form=custom-query]')
      i = 0
      while i < queryFields.length
        query = new DeltaQuery($(queryFields[i]))
        query.init()
        queries.push(query)
        i++

    validateAllQueries = ->
      allValid = true
      i = 0
      while i < queries.length
        if !queries[i].isValid()
          queries[i].showErrors()
          allValid = false
        i++
      return allValid
    addQueryListeners()
    queries[0].uploadForm.submit (e) ->
      e.preventDefault()
      $(this).unbind('submit').submit() if validateAllQueries()

  ## Delta queries validation and error handling ends

  ## Collapsible schema
  schema.find('#schema-pad').on 'hide.bs.collapse', ->
    schema.find('[href=#schema-pad]').fadeOut(200, ->
      $(this).text('reveal').fadeIn()
    )

  schema.find('#schema-pad').on 'show.bs.collapse', ->
    schema.find('[href=#schema-pad]').fadeOut(200, ->
      $(this).text('collapse').fadeIn()
    )
  ## Collapsible schema ends

  ## Schema tables and columns manipulation

  schema.on 'click', '[data-form=add-table]', (e) ->
    e.preventDefault()
    tablesContainer.append(templates().tableFields(table_id: uniqRecId()))
    addQueryListeners() if typeof addQueryListeners == 'function'

  schema.on 'click', '[data-form=remove-table]', (e) ->
    e.preventDefault()
    parent = $(@).parents('[data-form=table-fields]')
    parent.find('[data-form=destroy]').val('true')
    parent.hide()

  schema.on 'click', '[data-form=add-column]', (e) ->
    e.preventDefault()
    e.stopPropagation()
    parent = $(@).parents('[data-form=table-fields]')
    tableId = parent.data("table-id")
    parent.find('[data-form=columns-container]').append(
      templates().columnFields(table_id: tableId, column_id: uniqRecId())
    )

  schema.on 'click', '[data-form=remove-column]', (e) ->
    e.preventDefault()
    parent = $(@).parents('[data-form=column-fields]')
    parent.find('[data-form=destroy]').val('true')
    parent.hide()

  ## Schema tables and columns manipulation ends

  ## Show extra fields if Oracle and MS SQL driver is selected in JDBC

  select = $('#transformation_jdbc_driver_id');
  regex = /oracle|mssql/i
  $dbField = $('.js-oracle-specific')
  select.on 'change', (e) ->
    if regex.test(select.val())
      $dbField.show();
    else
      $dbField.hide();

  ## Show extra fields if Oracle driver is selected in JDBC ends

  ## Schema autodetection

  $('#autodetect_schema').click (e) ->
    e.preventDefault()
    $btn = $(e.target)
    animationTime = 200
    params = {
      uri: $('.x-jdbc-database-uri').val()
      username: $('.x-jdbc-user').val()
      password: $('.x-jdbc-password').val()
      jdbc_driver_id: $('.x-jdbc-driver-id').val()
    }
    params.database = $('.x-jdbc-database').val()  if regex.test(select.val())
    $.ajax(
      url: $(@).attr('href'),
      data: params,
      beforeSend: ->
        $btn.fadeOut(animationTime, ->
          $btn.parent().append($('<div class="spinner"><p>Detecting...</p><img src="/images/ajax-loader.gif" /></div>').hide().fadeIn(animationTime))
        )

      complete: ->
        $('.spinner').fadeOut(animationTime, ->
          $btn.fadeIn(animationTime)
          $(this).remove()
        )

    ).done((schemaData) ->
      if schemaData
        tables = $('#tables-container').find('[data-form=table-fields]')
        tables.find('[data-form=destroy]').val('true')
        tables.hide()

        domain = schemaData['typeDomain']
        $('.domain_hidden_field').val(domain)

        for table in schemaData['tables']
          tableId = uniqRecId()
          tablesContainer.append(
            templates().tableFields(table_id: tableId, name: table['name'])
          )
          columnsContainer = tablesContainer.find(
            '[data-form=columns-container]:last'
          )
          # Template contains one default column, let's remove it.
          columnsContainer.html("")

          for column in table['columns']
            columnsContainer.append(
              templates().columnFields(
                table_id: tableId,
                column_id: uniqRecId(),
                name: column.name,
                descr: column.descr,
                type: column.type
              )
            )

          addQueryListeners() if typeof addQueryListeners == 'function'
      else
        LineaAlert("Error: no schema detected", "No JDBC schema detected based on the connection info.", true)
    ).fail((error) ->
      message = if error.responseJSON.hasOwnProperty("message") then error.responseJSON.message else "No JDBC schema detected based on the connection info."
      LineaAlert("Error: no schema detected", message, true)
    )
  ## Schema autodetection ends
