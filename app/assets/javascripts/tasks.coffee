jQuery ->
  $('.modal-opener').on 'click', ->
    taskid = $(this).data('taskid')
    $.ajax "/tasks/#{taskid}/task_modal_html",
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "Nastala chyba pri získavaní detailu tasku."
      success: (data, textStatus, jqXHR) ->
        $('#task-modal').html(data).modal('show')
        $('.ui.dropdown').dropdown() # reload
        $('.task-list-updater').on "click", ->
          state = $(this).attr('state')
          tasklistId = $(this).attr('tasklistId')
          tthis = $(this) # V success je iny this
          $.ajax "/task_lists/#{tasklistId}/update_state",
            type: 'PATCH'
            dataType: 'html'
            error: (jqXHR, textStatus, errorThrown) ->
              alert("Nastala chyba pri updatovaní bodov na splnenie: #{textStatus}")
            success: (data, textStatus, jqXHR) ->
              iconUpdater = $(tthis).find(".icon-updater")
              contentUpdater = $(tthis).find(".content-updater")
              if state == "dokončená"
                iconUpdater.removeClass('green checkmark box icon icon-updater')
                iconUpdater.addClass('red square outline icon icon-updater')
                contentUpdater.removeClass('doneTask')
                contentUpdater.addClass('undoneTask')
                $(tthis).attr('state', "nedokončená")
              else
                iconUpdater.removeClass('red square outline icon icon-updater')
                iconUpdater.addClass('green checkmark box icon icon-updater')
                contentUpdater.removeClass('undoneTask')
                contentUpdater.addClass('doneTask')
                $(tthis).attr('state', "dokončená")
