# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
$ ->
  sections = [
    {
      button: $('#once_radio_button')
      group:  $()
    }, {
      button: $('#every_radio_button')
      group:  $('#every_group')
    }, {
      button: $('#cron_radio_button')
      group:  $('#cron_group')
    }
  ]

  for section in sections
    do (section) ->
      section.button.click ->
        s.group.hide() for s in sections
        section.group.show()

    unless section.button.is(':checked')
      section.group.hide()
