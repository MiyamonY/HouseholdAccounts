$(function(){
    $("#delete-button").click(function(e) {
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
});
