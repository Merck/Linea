# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
$ ->
  replaceTextwSpinner = (el) ->
    elText = el.text()
    el.html("<img src='/images/ajax-loader.gif' width='100px'>")
    el.addClass('disabled')
    return elText

#Show status in modal behavior
  $("body").on "click", "#get-transformation-status-all", (e) ->
#  $("body").on "click", "#get-transformation-status", (e) ->
    e.preventDefault()
    btn = $(e.target)
    btnText = ""
#    transformationStatusModal = $("#transformation-status-modal");
    transformationStatusDiv = $("#transformation-status-div");
    transformationStatusListTemplate = $("#transformation-status-list-template")
#    if transformationStatusModal != null && transformationStatusModal.length > 0
    return if transformationStatusDiv != null && transformationStatusDiv.html().length > 0
# Checks if the modal was already rendered.
# Prevents multiple equal modals to be appended to the page.
#      transformationStatusListTmpl.modal()
      $.ajax(
        url: btn.data("datasetid"),
        beforeSend: ->
          btnText = replaceTextwSpinner(btn)
        complete: ->
          btn.text("REFRESH")
          btn.removeClass('disabled')
        error: (xhr, status, err) ->
#          transformationModalTemplate = $("#transformation-status-modal-template")

          transListStatusCompiled = Handlebars.compile(transformationStatusListTemplate.html())
          contentEl = $(transListStatusCompiled(message: err + ": " + xhr.status ))
          transformationStatusDiv.html(contentEl)

        success: (xhr) ->
#          $transformationStatus = $("#transformation-status-modal-template")
          if transformationStatusListTemplate? and transformationStatusListTemplate.length > 0
            compiledTemplate = Handlebars.compile(transformationStatusListTemplate.html())
            if xhr.fail
              transformationStatusDiv.html("<div class='alert alert-danger' role='alert'>"+xhr.message+"</div>")
            else
              contentEl = $(compiledTemplate(response: xhr))
              transformationStatusDiv.html(contentEl)
        )

  $("body").on "click", "#get-transformation-status-inline", (e) ->
    e.preventDefault()
    btn = $(e.target)
    dataset = btn.closest('.dataset-result-row')
    btnText = ""
    transformationStatusBlock = dataset.find("#transformation-status-block")
    transformationBlockTemplate = $("#transformation-status-inline-template")
    return if transformationStatusBlock != null && transformationStatusBlock.length > 0
    $.ajax(
      url: btn.data("datasetid"),
      beforeSend: ->
        btnText = replaceTextwSpinner(btn)
      complete: ->
        btn.slideUp(400)
      error: (xhr, status, err) ->

        blockTemplate = Handlebars.compile(transformationBlockTemplate.html())
        blockEl = $(blockTemplate(message: err + ": " + xhr.status ))
        blockEl.appendTo(dataset.find('.dataset-result-column'))
      success: (xhr) ->
        modalTemplate = Handlebars.compile(transformationBlockTemplate.html())
        if xhr.fail
          modalEl = $(modalTemplate(message: xhr.message))
        else
          instance = xhr.transformation_instance
          reloadable = instance.status is ("RUNNING" or "STARTING")
          modalEl = $(modalTemplate(transformation: instance, reloadable: reloadable))
        modalEl.appendTo(dataset.find('.dataset-result-column')).hide().delay(600).slideDown()

        #add special classes to dataset container, depending on the transformation status
        if instance
          switch instance.status
            when "FAILED", "ERROR"
              dataset.addClass('dataset-info--failed')
              return
            when "RUNNING", "STARTING"
              dataset.addClass('dataset-info--running')
              return

    )

  humaniseStatus  = (status) ->
    switch status
      when "RUNNING", "STARTING"
        return "Downloading data into new dataset..."
      when "FAILED", "ERROR"
        return "Dataset was created. Downloading data failed."
      when "SUCCEEDED"
        return "Loading successfully finished."
      else
        return "Current status: " + status.toLowerCase()

  getDaysPassed = (startDate, endDate) ->

    DAY = 1000 * 60 * 60  * 24
    d1 = new Date(startDate)
    d2 = new Date(endDate)
    days_passed = Math.round((d2.getTime() - d1.getTime()) / DAY)


  getShortDate = (dateObj) ->

    sDate = ""
    if dateObj
      d = new Date(dateObj)
      day = d.getDate()
      month = d.getMonth() + 1
      year = d.getFullYear()
      hours = d.getHours() - 1
      minutes = d.getMinutes()
      sDate =  day+ '.'+month+'.'+year
    else
      sDate

  getShortTime = (dateObj) ->
    sTime = ""
    if dateObj
      sTime =  "#{ dateObj.substring(11,16) }  #{ dateObj.substring(20, 23) }"
    else
      sTime


  getTimeTaken = (sDate,eDate) ->

    if sDate
        HOUR = 1000 * 60 * 60
        MINUTE  = 1000 * 60
        DAY = 24 * 60 * 60 * 1000
        d1 = new Date(sDate)
        d2 = if eDate then new Date(eDate) else new Date()

        diffTime = Math.round(d2.getTime() - d1.getTime())

        hours = Math.floor(diffTime / HOUR)
        minutes = Math.ceil(diffTime / MINUTE)

        $days = Math.floor(diffTime / (DAY))
        $daysms = diffTime % (DAY)
        $hours = Math.floor(($daysms) / (HOUR))
        $hoursms = diffTime % (HOUR)
        $minutes = Math.ceil(($hoursms) / (MINUTE))
        $minutesms=diffTime % (MINUTE)
        $sec = Math.floor(($minutesms) / (1000))

        if $days > 0
          days = "#{ $days } days"
        else
          days = ""

        if $hours > 0
          hours = " #{ $hours } hours"
        else
          hours = ""

        if $minutes > 0
          minutes = " #{ $minutes } minutes"
        else
          minutes = ""

        timeTaken = days + hours + minutes


  humaniseDateFormat =  (dateObj) ->
      shortDate = ""
      timeFormat = ""
      days = getDaysPassed(dateObj, new Date)
      switch this.status
        when "RUNNING", "STARTING"
          prefix = "running"
        else
          prefix  = "took"
      runningTime = "(#{prefix} #{getTimeTaken(this.startDate, this.endDate)})"
      timeFormat = getShortTime(dateObj)
      shortDate  = getShortDate(this.endDate)
      switch days
        when 1
          return "yesterday #{ timeFormat } #{ runningTime }"
        when 0
          return "today #{ timeFormat } #{ runningTime }"
        else
          return "#{ shortDate } #{ timeFormat }  #{ runningTime }"

  formatStatusValues  = (status) ->

    if status
      switch status
        when "RUNNING", "STARTING", 'PREP', 'USER_RETRY', 'START_RETRY', 'START_MANUAL', 'END_RETRY', 'END_MANUAL'
          return "in-progress"
        when 'KILLED', "FAILED", "ERROR"
          return "failed"
        when "SUCCEEDED", 'OK', 'DONE'
          return "completed"
        else
          return "Current status: " + status.toLowerCase()

  toggleStatusClass = (item) ->
    switch this.status
      when 'KILLED', 'FAILED', 'ERROR'
        return className = "trans-history-fail"
      when "SUCCEEDED", 'OK', 'DONE'
        return className = "trans-history"
      when "RUNNING", "STARTING", 'PREP', 'USER_RETRY', 'START_RETRY', 'START_MANUAL', 'END_RETRY', 'END_MANUAL'
        return className = "trans-history-progress"

  toggleStatusIcon = (item) ->
    switch this.status
      when 'KILLED', 'FAILED', 'ERROR'
        return "glyphicon glyphicon-remove"
      when "SUCCEEDED", "OK", "DONE"
        return "glyphicon glyphicon-ok"
      when "RUNNING", "STARTING", "RUNNING", "STARTING", 'PREP', 'USER_RETRY', 'START_RETRY', 'START_MANUAL', 'END_RETRY', 'END_MANUAL'
        return "glyphicon glyphicon-play"


  iff = (a, operator, b, opts) ->
    bool = false
    switch operator
      when "=="
        bool = a == b
      when ">"
        bool = a > b
      when "<"
        bool = a < b
      when ">="
        bool = a >= b
      when "=<"
        bool = a <= b
      else
        "Unknown operator"

    if bool
        opts.fn(this)
      else
        opts.inverse(this)




  #Helper to turn the statuses into human readable sentences
  Handlebars.registerHelper("humaniseDateFormat": humaniseDateFormat);
  Handlebars.registerHelper("getShortDate": getShortDate);
  Handlebars.registerHelper("humaniseStatus": humaniseStatus);
  Handlebars.registerHelper("formatStatusValues": formatStatusValues);
  Handlebars.registerHelper("toggleStatusClass": toggleStatusClass);
  Handlebars.registerHelper("toggleStatusIcon": toggleStatusIcon);
  Handlebars.registerHelper("iff": iff);



  dataset = $('.dataset-result-row')

  dataset.first().find("#get-transformation-status-inline").click() if dataset.length


  $("body").on "click", "#get-transformation-status-log", (e) ->
    e.preventDefault()
    btn = $(e.target)
    btnText = btn.text()
    transformationStatusModalTmpl = $("#transformation-status-modal-template");
    transformationStatusModalDiv = $("#transformation-status-modal")
    actionsBtn = $("#actions-btn")
    transformation_status = formatStatusValues(btn.data("status"))
    transformation_id = btn.data("transformationid")
    transformation_instance_id = btn.data("transformationinstanceid")
    $.ajax(
      url: btn[0].getAttribute("href"),
      data: { transformation_id: transformation_id, transformation_instance_id: transformation_instance_id }
      beforeSend: ->
        btnText = replaceTextwSpinner(btn)
      complete: (data) ->
        btn.text("Show logs")
        btn.removeClass('disabled')
        if arguments[0] && arguments[0].responseJSON && arguments[0].responseJSON.logs
          result_logs = arguments[0].responseJSON.logs
          active_log_type = result_logs.active_log
          actionIndex = result_logs.error_log_index || result_logs.system_log_index
          actionName = result_logs.action_list[actionIndex].action_name
          actionsBtn.html('actions-'+actionIndex + '<span ' +'class="caret"></span>')
          actionsBtn.val(actionName)
        $log_types = $(".label[id='get-transformation-log-by-type']")
        if $log_types
            $log_types.toggleClass('item-inactive', true)
            $log_type = $(".label[data-logtype='"+active_log_type+"']")
            if $log_type
                $log_type.toggleClass('item-inactive', false)

      error: (xhr, status, err) ->
      success: (data, status, response) ->
        if transformationStatusModalTmpl? and transformationStatusModalTmpl.length > 0
          compiledTemplate = Handlebars.compile(transformationStatusModalTmpl.html())
          if data.fail
            data.logs = { transformation_instance: transformation_instance_id }
            contentEl = $(compiledTemplate({data: data, transformation_status: 'failed', transformation_id: transformation_id}))
            transformationStatusModalDiv.html(contentEl)
            contentEl.appendTo('body').modal()
          else
            default_log = data.logs.default_error_log || data.logs.default_system_log
            action_index = if data.logs.error_log_index > -1 then data.logs.error_log_index else if data.logs.system_log_index > -1  then  data.logs.system_log_index
            action_name = data.logs.action_list[action_index].action_name
            active_log = data.logs.active_log
            contentEl = $(compiledTemplate(transformation_id: transformation_id, active_log: active_log, transformation_status: transformation_status, data: data, default_log: default_log, action_list: data.logs.action_list, action_index: action_index, action_name: action_name))
            transformationStatusModalDiv.html(contentEl)
            contentEl.appendTo('body').modal()
    )


  $("body").on "click", "#get-transformation-log-by-type", (e) ->
    e.preventDefault()
    btn = $(e.target)
    btnText = btn.text()

    transformationStatusModalTmpl = $("#transformation-status-modal-template");
    transformationStatusModalDiv = $("#transformation-status-modal")

    panelLogBody = $("#panel-log-body")
    transIdLbl = $("#trasnformation-id-lbl")
    actionBtn = $("#actions-btn")
    log_type = btn[0].dataset.logtype
    action_name = actionBtn[0].value
    transformation_id_instance = transIdLbl[0].textContent
    transformation_id  = transIdLbl[0].dataset.transid

    $.ajax(
      url: btn[0].getAttribute("href"),
      data: {
          transformation_id: transformation_id,
          transformation_instance_id: transformation_id_instance,
          action_name: action_name, log_type: log_type
      }
      beforeSend: ->
        btnText = replaceTextwSpinner(btn)
        panelLogBody.html("<center><img src='/images/ajax-loader.gif'></center>")
        panelLogBody.addClass('disabled')

      complete: ->
        btn.text(btnText)
        btn.removeClass('disabled')
        panelLogBody.removeClass('disabled')
        $log_items = $(".label[id='get-transformation-log-by-type']")
        for log_item in $log_items
          $(log_item).toggleClass('item-inactive', true)
        btn.toggleClass('item-inactive', false)
      error: (xhr, status, err) ->
      success: (data, status, response) ->
          if data.fail
            panelLogBody.html(data)
          else
            horizontal_line = "<div class='horizontal-line-bold'></div>"
            if data.logs == 'Log is empty\n'
              panelLogBody.html("<center>" + data.logs+"</center>")
            else
              panelLogBody.html(data.logs + horizontal_line)
    )


    selectDefaultFailedAction  = (action) ->
      if action
        switch  action.message.status
          when "KILLED", "FAILED", "ERROR"
            return action

  $("body").on "click", "#showMoreBtn", (el) ->
    btn = el.target;
    elText = btn.textContent.trim()
    if elText == 'Show more'
      btn.textContent = "Collapse"
    else
      btn.textContent = "Show more"
    return elText

  $("body").on "click", "#actions-dropdown-menu li span a", (el) ->
    element = el.target
    btn = $("#actions-btn")
    btn.html(this.text + '&nbsp;<span class="caret"></span>')
    btn.val(this.dataset.index)
    stderr_a = $(".label[data-logtype='stderr']")
    if stderr_a
       stderr_a.click()