// -*- conding: utf-8 -*-
$(function(){
    $('#date').calendar({type:'date',
                         formatter: {
                             date: function (date, settings) {
                                 if (!date) return '';
                                 var day = date.getDate();
                                 var month = date.getMonth() + 1;
                                 var year = date.getFullYear();
                                 return year + '-' + month + '-' + day;
                             }
                         }
                        });

    $('div.label').click(function(e){
        $('#etc').val($(this).data('value'));
    });
});
