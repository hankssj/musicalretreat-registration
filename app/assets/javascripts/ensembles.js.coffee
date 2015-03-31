class EnsemblesForm
  listen: =>
    @handleMorningEnsembleChoice($('.morning-ensemble-choices input:checked'))

    $('.chamber-group-partial').each (i, partial)=>
      instrument = $(partial)
        .find('.arranged-chamber-group-instrument')
      isJazz = instrument.find('option:selected').data('jazz')
      isString = instrument.find('option:selected').data('string')
      @handleArrangedChamberInstrument(isJazz, isString, partial)

      is_contact = $(partial).find('.is-contact:checked').val()
      @handlePrearrangedChamberContact(is_contact, partial)

      show_bring_own_music_input = $(partial).find('.own-music:checked').val()
      @handlePrearrangedChamberMusic(show_bring_own_music_input, partial)

    $('.morning-ensemble-choices input').on 'click', (e) =>
      @handleMorningEnsembleChoice($(e.target).val())

    $('.ensembles_select').each (i, select) =>
      @blockProperEnsemblePreferencesChoices(select)

    $('#choosen-electives').sortable
      connectWith: '#aviliable-electives'
      items: "li:not(.placeholder)"
      remove: (event, ui)->
      axis: 'y'
      receive: (event, ui)->
        $(this).sortable('refresh')
        $(ui.sender).draggable('disable')
        $(ui.sender).find('input, select').prop('disabled', false)
        $('#choosen-electives .placeholder').addClass('hidden')
        if($(this).children().not('.placeholder').length >= 5)
          $('#aviliable-electives li').draggable('disable')
      update: ->
        $(this).children().not('.placeholder').each (i, item)->
          console.log(i+1)
          $(item).find('.rank').val(i+1)
    .disableSelection()

    $('#choosen-electives').on 'click', 'li .remove', ->
      if ($('#choosen-electives').children().not('.placeholder').length <= 1)
        $('#choosen-electives .placeholder').removeClass('hidden')
      $li = $(this).closest('li')
      $li.removeAttr('style')
      $li.css('position', 'relative')
      $li.prependTo('#aviliable-electives')
      $li.fadeIn(100).fadeOut(100).fadeIn(100)
      $li.find('input, select').prop('disabled', true)
      $('#aviliable-electives li').draggable('enable')

    $('.sortable-electives li').draggable
      connectToSortable: '#choosen-electives'
      revert: 'invalid'
      revertDuration: 1
    .disableSelection()

    $('#choosen-electives li').draggable('disable')
    if($('#choosen-electives').children().not('.placeholder').length >= 5)
      $('#aviliable-electives li').draggable('disable')


    $('.sortable-electives li:not(.placeholder)').on 'mouseenter', (e) ->
      $('#info-box').removeClass('hidden')
      $('#info-box .description').text($(this).find('.descritpion').text())
      $('#info-box .name').text($(this).find('.name').text())

    $('.arranged-chamber-group-instrument').on 'change', (e) =>
      isJazz = $(e.target).find('option:selected').data('jazz')
      isString = $(e.target).find('option:selected').data('string')
      container = $(e.target).closest('.chamber-group-partial')
      @handleArrangedChamberInstrument(isJazz, isString, container)

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

    $('.ensembles_select').on 'change', (e) =>
      choosed_prearranged_ensembles = $('#ensemble_primary_choosed_prearranged_ensembles').val()
      choosed_assigned_ensembles = $('#ensemble_primary_choosed_assigned_ensembles').val()

      @handleChamberEnsemblePreferencesChoice(choosed_prearranged_ensembles, choosed_assigned_ensembles)

      @blockProperEnsemblePreferencesChoices(e.target)

    $('.overall-rating .beginner, .overall-rating .novice, .overall-rating .intermediate, .overall-rating .experienced, .overall-rating .advanced').on 'mouseenter', (e)->
      level = $(e.target).attr('class')
      $(".skill-description p").addClass('hidden')
      $(e.target).closest('.overall-rating').find(".#{level}-text").removeClass('hidden')

    $('.beginner, .novice, .intermediate, .experienced, .advanced').on 'mouseleave', (e)->
      level = $(e.target).attr('class')
      $(".skill-description p").addClass('hidden')

    $('.checkbox-with-relative input[type=checkbox]').on 'change', (e)->
      if $(e.target).is(':checked')
        $(e.target).closest('.checkbox-with-relative').find('.relative-input').removeClass('hidden')
      else
        $(e.target).closest('.checkbox-with-relative').find('.relative-input').addClass('hidden')

    $('#terms').on 'change', (e)->
      if $(e.target).is(':checked')
        $('.submit-ensemble').prop('disabled', false)
      else
        $('.submit-ensemble').prop('disabled', true)

    $('.submit-ensemble').on 'click', ->
      $('.edit_ensemble_primary').submit()

  handleMorningEnsembleChoice: (value)->
    if value == '0'
      $('.toggled-morning-ensemble-options').hide()
    else
      $('.toggled-morning-ensemble-options').show()

  handleArrangedChamberInstrument: (isJazz, isString, container)->
    if isJazz
      $('.only-for-jazz', container).show()
    else
      $('.only-for-jazz', container).hide()
    if isString
      $('.only-for-string', container).show()
    else
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
  handleChamberEnsemblePreferencesChoice: (choosed_prearranged_ensembles, choosed_assigned_ensembles) =>
    chamber_ensemble_choice = $('#ensemble_primary_chamber_ensemble_choice')

    if(choosed_prearranged_ensembles == choosed_assigned_ensembles == '0')
      chamber_ensemble_choice.val('0')
    else if(choosed_prearranged_ensembles == '0' && choosed_assigned_ensembles == '1')
      chamber_ensemble_choice.val('1')
    else if(choosed_prearranged_ensembles == '1' && choosed_assigned_ensembles == '0')
      chamber_ensemble_choice.val('2')
    else if(choosed_prearranged_ensembles == '0' && choosed_assigned_ensembles == '2')
      chamber_ensemble_choice.val('3')
    else if(choosed_prearranged_ensembles == '1' && choosed_assigned_ensembles == '1')
      chamber_ensemble_choice.val('4')
    else if(choosed_prearranged_ensembles == '2' && choosed_assigned_ensembles == '0')
      chamber_ensemble_choice.val('5')
    else if(choosed_prearranged_ensembles == '3' && choosed_assigned_ensembles == '0')
      chamber_ensemble_choice.val('6')

  blockProperEnsemblePreferencesChoices: (element) =>
    selected_val = $(element).val()
    $('.ensembles_select option').prop('disabled', false)
    $('.ensembles_select').each (i, select) =>
      if element != select
        $(select).find('option').each (j, o)->
          if selected_val > 1 && $(o).val() > 0
            $(o).prop('disabled', true)
          if selected_val == '1' && $(o).val() > 1
            $(o).prop('disabled', true)

$(document).on 'ready page:load', ->
  ensemblesForm = new EnsemblesForm
  ensemblesForm.listen()
