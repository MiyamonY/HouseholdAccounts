$(function(){
    $(".label.detail").click(function(e){
        var account_id = $(this).data('value');
        $("#detail-" + account_id).modal('show');
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

    $("button[name=correct]").click(function(e) {
        var button = this;
        $("<input>").attr("type", "hidden")
            .attr("name", button.name).val(button.value).appendTo("#form");
        $("#form").submit();
    });

});
