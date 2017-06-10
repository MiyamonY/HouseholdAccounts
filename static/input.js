// -*- conding: utf-8 -*-
$(function(){
    $('.ui.form').form({
        fields: {
            date: {
                indentifier: 'date',
                rules:[{
                    type: 'empty',
                    prompt: "日付を入力して下さい"
                }]
            },
            member: {
                indentifier: 'member',
                rules:[{
                    type: 'empty',
                    prompt: "支払った人を入力して下さい"
                }]
            },
            kind: {
                indentifier: 'kind',
                rules:[{
                    type: 'empty',
                    prompt: "項目を入力して下さい"
                }]
            },
            amount: {
                indentifier: 'amount',
                rules:[{
                    type: 'integer',
                    prompt: "金額を数値で入力して下さい"
                }],
                rules:[{
                    type: 'empty',
                    prompt: "金額を入力して下さい"
                }]

            }
        }
    });

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
