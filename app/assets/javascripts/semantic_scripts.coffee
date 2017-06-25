# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev("input[type=hidden]").val("1");
    $(this).closest(".field-holder").hide();

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('.pop_up').popup({
    hoverable: true,
    position: 'top left'
  });

  $('.pop_up_on_click').popup({
    on: 'click'
    position: 'right center'
  })

  $('.menu .browse').popup({
    inline: true,
    hoverable: true,
    position: 'bottom left'
  })

  $(".message.closable").on "click", ->
    $('.message.closable').fadeOut("slow")
    false

  $('.ui.dropdown').dropdown(
    on: 'hover',
    direction: 'downward',
    forceSelection: false,
    duration: 200,
    delay: {
      hide: 100,
      show: 20
    }
  )

  $('.ui.search.dropdown').dropdown(
    on: 'hover',
    direction: 'downward',
    forceSelection: false,
    duration: 200,
    delay: {
      hide: 100,
      show: 20
    },
    fullTextSearch: true
  )

  $('.ui.sidebar')
    .sidebar({
      context: '.pusher'
    })
    .sidebar()

  $.datepicker.setDefaults($.datepicker.regional['sk']);
  $.timepicker.regional['sk'] = {
    timeOnlyTitle: 'Vyberte čas',
    timeText: 'Čas',
    hourText: 'Hodiny',
    minuteText: 'Minúty'
    currentText: 'Teraz',
    closeText: 'Zatvoriť',
    timeFormat: 'HH:mm'
  };
  $.timepicker.setDefaults($.timepicker.regional['sk']);

  $('.datepick')
  .datepicker({
  })

  $('.datetimepick')
  .datetimepicker({
    addSliderAccess: true,
    sliderAccessArgs: {touchonly: false}
  })

  $('.ui.accordion').accordion();

  $(".accordion-closer").on "click", ->
    $('.accordion').toggle();

  $('.ui.sticky').sticky({
    offset: 200,
    bottomOffset: 50,
    context: '#stickable'
  })

  $('.ui.embed').embed();

  $('.special.cards .dimmer').dimmer({
    on: 'hover'
  });

#  calendar_update = ->
#    $('.popup.demos .browse').popup({
#      on: 'hover',
#      inline: true,
#      hoverable: true,
#      position: 'bottom left'
#    })
#
#  $(document).on 'page:load', ->
#    calendar_update()

#  $('.popup.demos .browse').popup({
#    on: 'hover',
#    inline: true,
#    hoverable: true,
#    position: 'bottom left'
#  })

#  $('.popup-creator').popup({
#    on: 'hover',
#    inline: true,
#    hoverable: true,
#    position: 'bottom left'
#  })

#  $('.pulse-on-hover').mouseenter(
#    (ev) ->
#      $(this).transition('pulse')
#  )

#  $('.pulse-on-timing')
#  .transition('set looping')
#  .transition('bounce', '1900ms')


  $('.menu .item').tab()

  $('.newsTicker').newsTicker({
    row_height: 47,
    max_rows: 10,
    duration: 4000
  });

  $('.ui.checkbox').checkbox();

  $('#event_list_why').on 'keyup', ->
    len = $(this).val().replace(/\s/g, "").length;
    if len < 350
      $('#display_count').html(
        "<span class=\"ui red circular label\">#{len}</span>"
      );
    else
      $('#display_count').html(
        "<span class=\"ui green circular label\">#{len}</span>"
      );

  $('.best_in_place').best_in_place();

  $('.event-calendar-list').on "click", ->
    day = $(this).attr('date')
    ids = $(this).data('ids')
    $.ajax "/homepage/meetings_html?ids=#{ids}",
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
        $('#modal-header').text("#{day}")
        $('#event_calendar_list').html("Nastala chyba pri načítavaní zoznamu.")
        $('#modal').modal('show')
      success: (data, textStatus, jqXHR) ->
#        alert(data)
        $('#modal-header').text("#{day}")
        $('#event_calendar_list').html(data)
        $('#modal').modal('show')

  $('#countup').appear()
  $('#countup').on "appear", ->
    counted = $(this).attr('counted')
    if counted == "false"
      endval = $('#cntup1').attr('end-val')
      demo = new CountUp('cntup1', 0, endval);
      demo.start();
      endval = $('#cntup2').attr('end-val')
      demo = new CountUp('cntup2', 0, endval);
      demo.start();
      endval = $('#cntup3').attr('end-val')
      demo = new CountUp('cntup3', 0, endval);
      demo.start();
      endval = $('#cntup4').attr('end-val')
      demo = new CountUp('cntup4', 0, endval);
      demo.start();
      $(this).attr('counted', 'true')

  $('#add-age-fields').on "click", ->
    actualHtml = $('#age-container').html()
    actcount = parseInt($(this).attr('actcount'), 10) + 1
    $(this).attr('actcount', actcount)
    $('#age-container').append(
      "<div class=\"two fields\">
          <div class=\"field\">
            <label>Od</label>
            <input type=\"number\" name=\"age_from_#{actcount}\" id=\"age_from_#{actcount}\" min=\"0\">
            </div>
            <div class=\"field\">
              <label>Do</label>
              <input type=\"number\" name=\"age_to_#{actcount}\" id=\"age_to_#{actcount}\" min=\"0\">
            </div>
         </div>"
    )

  #  $('.document-cell-click').on "click", ->
  #    row = $(this).attr('row')
  #    col = $(this).attr('col')
  #    actVal = $("#csv_#{row}_#{col}").val()
  #    $('#modal-header').text("Vyplnenie štatistiky do riadku #{row}, stĺpca #{col}.")
  #    $('#top-content').text("Aktuálna hodnota je: '#{actVal}'.")
  #    $('#content').html("Content")
  #    $('#modal').modal('show')

  $(".hiding").on "click", ->
    $(".hideable").hide

  $("#moving-ship").on "click", ->
    clickCnt = parseInt($(this).parent().attr("clickCnt")) + 1
    $(this).parent().attr("clickCnt", clickCnt)
    w = $(this).parent().width()
    $(this).attr("src", "/assets/lodka.svg");
    $(this).animate(
      {left: "+=#{w}"},
      5000,
      ->
        $(this).attr("src", "/assets/lodka.svg")
        $(this).addClass("flipped")
    )
    $(this).animate(
      {left: "-=#{w}"},
      5000,
      ->
        $(this).removeClass("flipped")
        if clickCnt <= 2
          $(this).attr("src", "/assets/lodka_tired.svg")
        else
          $(this).attr("src", "/assets/lodka_tired2.svg")
    )
  $("#moving-ship").click()

  $(".rolluptolink").on "click", ->
    link = $(this).attr("link")
    $("##{link}").hover()

  $(".add-to-recommender").on "click", ->
    card = $(this).parent()
    tthis = $(this)
    id = $(this).attr("rid")
    title = $(this).attr("rtitle")
    thumbnail_url = $(this).attr("rthumbnail")
    url = $(this).attr("rurl")
    if confirm("Naozaj chceš pridať článok/video na doporučovanie?")
      $.ajax "/recommenders/#{id}/add?title=#{title}&thumbnail_url=#{thumbnail_url}&url=#{url}",
        type: 'PATCH'
        dataType: 'html'
        error: (jqXHR, textStatus, errorThrown) ->
          alert("Nastala chyba pri pridávaní článku/videa na doporučenie")
        success: (data, textStatus, jqXHR) ->
          tthis.remove() # remove "add" button
          $('#content-holder').append("<div class=\"card\">" + card.html() + "</div>")
          card.remove()

  $(".recommendation-remover").on "click", ->
    card = $(this).parent()
    id = $(this).attr("rid")
    if confirm("Naozaj chceš odobrať článok/video z doporučovania?")
      $.ajax "/recommenders/remove?recommendation_id=#{id}",
        type: 'DELETE'
        dataType: 'html'
        error: (jqXHR, textStatus, errorThrown) ->
          alert("Nastala chyba pri odoberaní článku/videa z doporučenia")
        success: (data, textStatus, jqXHR) ->
          card.remove()

  $(document).ajaxStart ->
    $("#ajax_loader").show()

  $(document).ajaxStop ->
    $("#ajax_loader").hide()

  $('.smejo').on 'click', ->
    if $(this).attr("src") == $(this).data("kukuc-usmiaty")
      $(this).attr("src", $(this).data("kukuc"))
    else
      $(this).attr("src", $(this).data("kukuc-usmiaty")).transition('tada')
      
  $('.ui.progress').progress()
