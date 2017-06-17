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
            color: {
                indentifier: 'color',
                rules:[{
                    type: 'empty',
                    prompt: "色を入力して下さい"
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

    $(".ui.button[name=correct]").click(function(e){
        var button = $(this);
        var id = button.val();
        var color_id = parseInt($('#tag-color-' + id).attr("data-value"));
        var name = $('#tag-name-' + id).attr("data-value");
        $('#tag-id').val(id);
        $('#tag-name').val(name);
        $('#tag-color-dropdown').dropdown('set selected', color_id);
        $("#tag-correct").modal({
            onDeny: function(){
            },
            onApprove: function(){
                $('#tag-correct-form').submit();
                return false;
            }}).modal("show");

    });
});
