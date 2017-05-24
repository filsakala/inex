# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('.cardAdder').on "click", ->
    $.ajax "/homepage_cards",
      type: 'POST'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').append "Nastala chyba pri pridávaní karty: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        $("#cardText").html('<div class="ui fluid green message"><i class="green checkmark icon"></i>Karta bola úspešne pridaná. Pre zobrazenie klikni na Uložiť.</div>')

  $('.cardDestroyer').on "click", ->
    cardId = $(this).attr('cardId')
    $.ajax "/homepage_cards/#{cardId}",
      type: 'DELETE'
      dataType: 'html'
      success: (data, textStatus, jqXHR) ->
        $("#card#{cardId}").remove()
        $("#cardText").html('<div class="ui fluid green message"><i class="green checkmark icon"></i>Karta bola úspešne vymazaná.</div>')

  $('.toggleIsVisible').on "click", ->
    cardId = $(this).attr('cardId')
    tthis = $(this)
    $.ajax "/homepage_cards/#{cardId}/toggle_is_visible",
      type: 'PUT'
      dataType: 'html'
      success: (data, textStatus, jqXHR) ->
        if $(tthis).attr("visible") == "1"
          tthis.removeClass('green')
          tthis.addClass('red')
          $(tthis).attr("visible", "0")
          $(tthis).attr("title", "Skryté na stránke")
          $("#cardText").html('<div class="ui fluid green message"><i class="green checkmark icon"></i>Karta bola úspešne nastavená ako neviditeľná.</div>')
        else
          tthis.removeClass('red')
          tthis.addClass('green')
          $(tthis).attr("visible", "1")
          $(tthis).attr("title", "Viditeľné na stránke")
          $("#cardText").html('<div class="ui fluid green message"><i class="green checkmark icon"></i>Karta bola úspešne nastavená ako viditeľná.</div>')

  $('.cardLeftMover').on "click", ->
    thisCard = $(this).closest(".card")
    prevCard = thisCard.prev(".card")
    if prevCard
      thisCardId = thisCard.attr("cardId")
      prevCardId = prevCard.attr("cardId")
      thisCardVal = $("##{thisCardId}_priority").val()
      prevCardVal = $("##{prevCardId}_priority").val()
      if typeof(prevCardId) != 'undefined' && typeof(prevCardVal) != 'undefined'
        $("##{thisCardId}_priority").val(prevCardVal)
        $("##{prevCardId}_priority").val(thisCardVal)
        $("#posViewer#{thisCardId}").text("Pos: #{prevCardVal}")
        $("#posViewer#{prevCardId}").text("Pos: #{thisCardVal}")
        $("#cardText").html('<div class="ui fluid green message"><i class="green checkmark icon"></i>Karta bola úspešne presunutá doľava. Ak chceš túto zmenu vidieť, klikni na Uložiť.</div>')


  $('.cardRightMover').on "click", ->
    thisCard = $(this).closest(".card")
    nextCard = thisCard.next(".card")
    if nextCard && typeof(nextCard) != 'undefined'
      thisCardId = thisCard.attr("cardId")
      nextCardId = nextCard.attr("cardId")
      thisCardVal = $("##{thisCardId}_priority").val()
      nextCardVal = $("##{nextCardId}_priority").val()
      if typeof(nextCardId) != 'undefined' && typeof(nextCardVal) != 'undefined'
        $("##{thisCardId}_priority").val(nextCardVal)
        $("##{nextCardId}_priority").val(thisCardVal)
        $("#posViewer#{thisCardId}").text("Pos: #{nextCardVal}")
        $("#posViewer#{nextCardId}").text("Pos: #{thisCardVal}")
        $("#cardText").html('<div class="ui fluid green message"><i class="green checkmark icon"></i>Karta bola úspešne presunutá doprava. Ak chceš túto zmenu vidieť, klikni na Uložiť.</div>')




