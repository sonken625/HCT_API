# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#generate_authentication_token')
    .on 'ajax:complete', (event) ->
      console.log(event.detail)
      response = $.parseJSON(event.detail[0].responseText)
      $('#authentication_token').val response.token

  $('#delete_authentication_token')
    .on 'ajax:complete', (event) ->
      $('#authentication_token').val ''