# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class EnsemblesForm
  listen: =>
    @handleMorningEnsembleChoice($('.morning-ensemble-choices input:checked'))
    $('.morning-ensemble-choices input').on 'click', (e)=>
      @handleMorningEnsembleChoice($(e.target).val())

  handleMorningEnsembleChoice: (value)->
    if value == '0'
      $('.toggled-morning-ensemble-options').hide()
    else
      $('.toggled-morning-ensemble-options').show()

$(document).on 'ready', ->
  ensemblesForm = new EnsemblesForm
  ensemblesForm.listen()
