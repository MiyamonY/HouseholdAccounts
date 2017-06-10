$(function(){
    $('.ui.form').form({
        fields: {
            name: {
                indentifier: 'name',
                rules:[{
                    type: 'empty',
                    prompt: "名前を入力して下さい"
                }]
            }
        }
    });

    $("button[name=delete]").click(function(e) {
        var button = this;
        $("#delete-confirm").modal({
            onDeny: function(){
            },
            onApprove : function() {
                $("<input>").attr("type", "hidden")
                    .attr("name", button.name).val(button.value).appendTo("#form");
                $("#form").submit();
            }}
        ).modal('show');
    });

    $("#tag-add-show").click(function(e){
        $("#tag-add").modal({
            onDeny: function(){
            },
            onApprove: function(){
                $('#tag-add-form').submit();
                return false;
            }}).modal("show");
    });
});
