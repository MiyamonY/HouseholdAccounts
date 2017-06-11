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
    update_detail_table(data);
    update_pagination_menu(data.num);
    update_active_pagination_button();
    $('#table-loader').removeClass("active");
}

function update_detail_table(data)
{
    $("#table-body").empty();
    for (i = 0; i < data.accounts.length; i ++){
        $("#table-body").append($(['<tr>',
                                   '  <td class="center">',
                                   data.accounts[i].date,
                                   '<a class="ui mini blue label detail" data-value="'+ data.accounts[i].id + '">info</a>',
                                   '  </td>',
                                   '  <td class="center">' + data.accounts[i].kind + '</td>',
                                   '  <td class="center">￥ ' + data.accounts[i].amount + '</td>',
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

function update_pagination_menu(num)
{
    var pagination_menu = $("#pagination-menu").empty();
    if(1 < num ){
        var arr1 = ['<div class="ui right floated pagination menu">',
                    '  <a class="icon item" id="left-page" data-value="1">',
                    '    <i class="left chevron icon"></i>',
                    '  </a>'];
        for(var i = 0; i < num; i++){
						var index	 = i + 1;
						arr1 = arr1.concat(['<a class="item page-button" data-value="' + index+ '">' + index + '</a>']);
				}
        var arr2  = ['  <a class="icon item" id="right-page" data-value="' + num + '">',
                     '    <i class="right chevron icon"></i>',
                     '  </a>',
                     '</div>'];
        var str = arr1.concat(arr2).join('\n')
        pagination_menu.append($(str));
    }
    attach_event_to_pagination_button();
}

function attach_event_to_pagination_button()
{
    $("a.page-button").click(function(e){
        var a = $(this);
        num = $(".active.page.button").attr("data-value");
        page = parseInt(a.attr("data-value"));
        send_receive_detail_table_req(num, page);
        return false;
    });

    $("a#left-page").click(function(e){
        if($(this).attr("data-value") < page){
            page -= 1;
            num = $(".active.page.button").attr("data-value");
            send_receive_detail_table_req(num, page);
        }
    });

    $("a#right-page").click(function(e){
        if(page < $(this).attr("data-value")){
            page += 1;
            num = $(".active.page.button").attr("data-value");
            send_receive_detail_table_req(num, page);
        }
    });

    $(".clickable.page.button").click(function(e){
        var button = $(this);

        num = button.attr("data-value");
        page = 1;
        send_receive_detail_table_req(num, page);
        update_active_page_num_button(button);
    });
}

function update_active_pagination_button()
{
    $("a.page-button").removeClass("active");
    $("a.page-button[data-value=" + page + "]").addClass("active");
}

function send_receive_detail_table_req(num, page)
{
    $('#table-loader').addClass("active");
    $.getJSON('/account/accounts',
			        {num: num,
               page: page},
              page_received);
}

function update_active_page_num_button(button)
{
    $(".page.button").removeClass("active");
    button.addClass("active");
}

$(function(){
    page = 1;

    num = $(".active.page.button").attr("data-value");
    send_receive_detail_table_req(num, page);

    $("#detail-delete").click(function(e) {
        var button = this;
        $("#delete-confirm").modal({
            onDeny: function(){
            },
            onApprove : function() {
                $("<input>").attr("type", "hidden")
                    .attr("name", button.name).val(button.value).appendTo("#delete-form");
                $("#delete-form").submit();
            }}
        ).modal('show');
    });

    $("#detail-correct").click(function(e) {
        var button = $(this);
        window.location.href = "/account/correct/" + button.attr("value");
    });
});
