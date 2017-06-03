$(function(){
    $('.ui.dropdown').dropdown();
    $('table.sortable').tablesort();
    $('.message .close').on('click', function() {
        $(this).closest('.message').transition('fade');
    });
});
