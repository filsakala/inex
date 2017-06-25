// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require jquery-ui/widgets/datepicker
//= require jquery-ui/i18n/datepicker-sk
//= require jquery-ui-timepicker
//= require semantic_ui/semantic_ui
//= require clipboard
//= require semantic_scripts
//= require homepage_cards
//= require permissions
//= require jquery.newsTicker.min
//= require jquery.sortable.min
//= require jquery.purr
//= require jquery.appear-master
//= require best_in_place
//= require best_in_place.jquery-ui
//= require countupjs/countUp
//= require tinymce-jquery
//= require data_tables
//= require contacts
//= require tasks

var set_positions;

set_positions = function () {
    // loop through and give each task a data-pos
    // attribute that holds its position in the DOM
    $('.item.with-id').each(function (i) {
        $(this).attr("data-pos", i + 1);
    });
}

// Init map search
function initMap() {
    $('.form.map-search').submit(); // Call updateMap - show all markers
}

$(document).ready(function () {

    var clip = new Clipboard('.copy_button');
    $('.field_with_errors').closest('.field').addClass('error');
    set_positions();
    $('.sortable').sortable();

    $('.sortable').sortable().bind('sortupdate', function (e, ui) {
        // array to store new order
        updated_order = []
        // set the updated positions
        set_positions();

        // populate the updated_order array with the new task positions
        $('.item.with-id').each(function (i) {
            updated_order.push({id: $(this).data("id"), position: i + 1});
        });

        // send the updated order via ajax
        $.ajax({
            type: "PUT",
            url: '/event_lists/sort',
            data: {order: updated_order}
        });
    });

    $('.sortable-columns').sortable().bind('sortupdate', function (e, ui) {
        eventTypeId = $(this).attr("eventTypeId")
        // array to store new order
        updated_order = []
        // set the updated positions
        set_positions();

        // populate the updated_order array with the new task positions
        $('.item.with-id').each(function (i) {
            updated_order.push({id: $(this).data("id"), position: i + 1});
        });

        // send the updated order via ajax
        $.ajax({
            type: "PUT",
            url: "/event_types/" + eventTypeId + "/event_tables/sort",
            data: {order: updated_order}
        });
    });

    tinyMCE.init({
        mode : "specific_textareas",
        editor_selector : "tinymce",
        plugins: [
            'uploadimage advlist autolink lists link image charmap print preview hr anchor',
            'searchreplace wordcount visualblocks visualchars code fullscreen',
            'insertdatetime media nonbreaking save table contextmenu directionality',
            'emoticons template paste textcolor colorpicker textpattern imagetools toc'
        ],
        toolbar1: 'preview | undo redo | bold italic forecolor backcolor | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image media emoticons',
        image_advtab: true,
        templates: [
            { title: 'Test template 1', content: 'Test 1' },
            { title: 'Test template 2', content: 'Test 2' }
        ]
    });
});
