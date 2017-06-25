# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
	$('.contacts').on 'click', ->
		$('.contact-tab').hide("slow")
		toShow = $(this).data('tab')
		$("#" + toShow).show("slow")
		# toggle background
		$('.cactive').removeClass('cactive')
		$(this).addClass('cactive')
	
	# Hide tabs by default
	$('.contact-tab').hide()
	$('#vseobecne').show()
