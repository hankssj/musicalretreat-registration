# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class EnsemblesForm
  listen: =>
    @handleMorningEnsembleChoice($('.morning-ensemble-choices input:checked'))

    $('.chamber-group-partial').each (i, partial)=>
      type = $(partial)
        .find('.arranged-chamber-group-instrument')
        .find('option:selected').data('type')
      @handleArrangedChamberInstrument(type, partial)

      is_contact = $(partial).find('.is-contact:checked').val()
      @handlePrearrangedChamberContact(is_contact, partial)

      show_bring_own_music_input = $(partial).find('.own-music:checked').val()
      @handlePrearrangedChamberMusic(show_bring_own_music_input, partial)

    $('.morning-ensemble-choices input').on 'click', (e) =>
      @handleMorningEnsemble($(e.target).val())

    $('.arranged-chamber-group-instrument').on 'change', (e) =>
      type = $(e.target).find('option:selected').data('type')
      container = $(e.target).closest('.chamber-group-partial')
      @handleArrangedChamberInstrument(type, container)

    $('.chamber-group-partial .is-contact').on 'change', (e) =>
      container = $(e.target).closest('.chamber-group-partial')
      @handlePrearrangedChamberContact($(e.target).val(), container)

      $(container).find('.own-music[value="false"]').prop('checked', true)
      @handlePrearrangedChamberMusic(false, container)

      $(container)
        .find('.contact-person-form input[type="text"], .contact-person-form textarea')
        .val('')

    $('.chamber-group-partial .own-music').on 'change', (e) =>
      container = $(e.target).closest('.chamber-group-partial')
      @handlePrearrangedChamberMusic($(e.target).val(), container)


  handleMorningEnsembleChoice: (value)->
    if value == '0'
      $('.toggled-morning-ensemble-options').hide()
    else
      $('.toggled-morning-ensemble-options').show()

  handleArrangedChamberInstrument: (type, container)->
    if type == 'string'
      $('.only-for-string', container).show()
      $('.only-for-jazz', container).hide()
    else if type == 'woodwind'
      $('.only-for-jazz', container).show()
      $('.only-for-string').hide()
    else
      $('.only-for-jazz', container).hide()
      $('.only-for-string', container).hide()
  handlePrearrangedChamberContact: (is_contact, container)=>
    if is_contact == "true"
      $('.contact-person-form', container).show()
      $('.non-contact-person-form', container).hide()
    else
      $('.contact-person-form', container).hide()
      $('.non-contact-person-form', container).show()
  handlePrearrangedChamberMusic: (show_bring_own_music_input, container)=>
    if show_bring_own_music_input == 'true'
      $('.own-music-form', container).show()
    else
      $('.own-music-form', container).hide()

$(document).on 'ready', ->
  ensemblesForm = new EnsemblesForm
  ensemblesForm.listen()
