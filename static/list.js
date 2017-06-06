function account_received(data, textStatus){
    $("#detail-date").text(data.date);
    $("#detail-kind").text(data.kind);
    $("#detail-amount").text("￥ " + data.amount);
    $("#detail-member").text(data.member);
    $("#detail-etc").text(data.etc);
    $("#detail-input-date").text(data.input_date);
    $("#detail-correct").attr("value", data.id);
    $("#detail-delete").attr("value", data.id);
    $("#detail-modal").modal('show');
}

$(function(){
    $(".label.detail").click(function(e){
        var account_id = $(this).data('value');
        $.getJSON('/account/account',
			            {id: account_id},
                  account_received
			           );
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
