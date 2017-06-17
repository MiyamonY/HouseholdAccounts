$(function(){
    $('.ui.dropdown').dropdown();
    $('table.sortable').tablesort();
    $('.message .close').on('click', function() {
        $(this).closest('.message').transition('fade');
    });

    $('form.ui.form').submit(function(e){
        if($('.ui.form').form('is valid')){
            $('.submit.button').addClass('loading');
            $('.cancel.button').addClass('loading');
            return true;
        } else {
            return false;
        }
    });
});
