# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

  $('.permissionToggler').on "click", ->
    row = $(this).closest("tr")
    controller = row.attr("controller")
    action = row.attr("action")
    role = $(this).attr("role")
    tthis = $(this)
    $.ajax "/permissions/toggle_permission?con=#{controller}&act=#{action}&role=#{role}",
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
        $("#descrText").html('<div class="ui fluid red message"><i class="red remove icon"></i>Nastala chyba pri zmene užívateľských práv.</div>')
      success: (data, textStatus, jqXHR) ->
        $("#descrText").html('<div class="ui fluid green message"><i class="green checkmark icon"></i>Užívateľské práva boli úspešne zmenené.</div>')
        if tthis.hasClass("green")
          tthis.removeClass('green checkmark link icon permissionToggler')
          tthis.addClass('red remove link icon permissionToggler')
        else
          tthis.removeClass('red remove link icon permissionToggler')
          tthis.addClass('green checkmark link icon permissionToggler')