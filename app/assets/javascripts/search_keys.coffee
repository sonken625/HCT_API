# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#update_search_key')
    .on 'ajax:complete', (event) ->
      response = $.parseJSON(event.detail[0].responseText)
      console.log(response)
      $('#search_key').val response.search_key

