$(function(){
    $('.ui.form').form({
        fields: {
            name: {
                indentifier: 'name',
                rules:[{
                    type: 'empty',
                    prompt: "名前を入力して下さい"
                }]
            },
            token: {
                indentifier: 'token',
                rules:[{
                    type: 'regExp[/^[0-9a-zA-z]*$/]',
                    prompt: "トークンは半角英数字のみで入力して下さい"
                }]
            }
        }
    })
});
