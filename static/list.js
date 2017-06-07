var page = 0;

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

function page_received(data, textStatus){
    $("#table-body").empty();

    for (i = 0; i < data.length; i ++){
        $("#table-body").append($(['<tr>',
                                   '  <td class="center">',
                                   data[i].date,
                                   '<a class="ui mini blue label detail" data-value="'+ data[i].id + '">info</a>',
                                   '  </td>',
                                   '  <td class="center">' + data[i].kind + '</td>',
                                   '  <td class="center">￥ ' + data[i].amount + '</td>',
                                   '</tr>'].join('\n')));
    };

    attach_detail_show_event();
}

function attach_detail_show_event()
{
    $(".label.detail").click(function(e){
        var account_id = $(this).attr("data-value");
        $.getJSON('/account/account',
			            {id: account_id},
                  account_received
			           );
    });
}

function update_active_pagination_button()
{
    $("a.page-button").removeClass("active");
    $("a.page-button[data-value=" + page + "]").addClass("active");
}

$(function(){
    page = 1;

    attach_detail_show_event();

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

    $("a.page-button").click(function(e){
        var a = $(this);
        page = a.attr("data-value");
        $.getJSON('/account/accounts',
			            {page: page},
                  page_received);
        update_active_pagination_button();
        return false;
    });

    $("a#left-page").click(function(e){
        if($(this).attr("data-value") < page){
            page -= 1;
            $.getJSON('/account/accounts',
			                {page: page},
                      page_received);
        }
        update_active_pagination_button();
    });

    $("a#right-page").click(function(e){
        if(page < $(this).attr("data-value")){
            page += 1;
            $.getJSON('/account/accounts',
			                {page: page},
                      page_received);
        }
        update_active_pagination_button();
    });

});
