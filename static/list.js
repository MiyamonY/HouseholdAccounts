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
        var date = data.accounts[i].date;
        var id = data.accounts[i].id;
        var kind = data.accounts[i].kind;
        var amount = data.accounts[i].amount;
        $("#table-body").append($(['<tr>',
                                   '  <td class="center" data-sort-value="'+ date.replace(/(\d+)-(\d+)-(\d+)/, '$1$2$3') + '">',
                                   date.replace(/(\d+)-(\d+)-(\d+)/, '$1年$2月$3日'),
                                   '<a class="ui mini blue label detail" data-value="'+ id + '">info</a>',
                                   '  </td>',
                                   '  <td class="center">' + kind + '</td>',
                                   '  <td class="center" data-sort-value="' + amount + '">￥ ' + amount + '</td>',
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

    if (num <= 1) return;

    var pre = ['<div class="ui right floated mini pagination menu">',
                    '  <a class="icon item" id="left-page" data-value="1">',
                    '    <i class="left chevron icon"></i>',
               '  </a>'];
    var post = ['  <a class="icon item" id="right-page" data-value="' + num + '">',
                '    <i class="right chevron icon"></i>',
                '  </a>',
                '</div>'];

    if (num <= 5) {
        for(var i = 0; i < num; i++) {
				    var index	 = i + 1;
				    pre = pre.concat(['<a class="item page-button" data-value="' + index+ '">' + index + '</a>']);
        }
		} else {
        if(page <= 3){
            for(var i = 0; i < 3; i++) {
				        var index	 = i + 1;
				        pre = pre.concat(['<a class="item page-button" data-value="' + index+ '">' + index + '</a>']);
            }
            pre = pre.concat(['<a class="item disabled">...</a>']);
        } else if ((num - 3) < page ){
            pre = pre.concat(['<a class="item disabled">...</a>']);
            for(var i = (num - 3); i  < num; i++) {
				        var index	 = i + 1;
				        pre = pre.concat(['<a class="item page-button" data-value="' + index+ '">' + index + '</a>']);
            }
        } else{
            pre = pre.concat(['<a class="item page-button" data-value="' + 1 + '">' + 1 + '</a>']);
            pre = pre.concat(['<a class="item disabled">...</a>']);
            pre = pre.concat(['<a class="item page-button" data-value="' + page + '">' + page + '</a>']);
            pre = pre.concat(['<a class="item disabled">...</a>']);
            pre = pre.concat(['<a class="item page-button" data-value="' + num + '">' + num + '</a>']);
        }
    }

    var str = pre.concat(post).join('\n');
    pagination_menu.append($(str));

    attach_event_to_pagination_button();
}

function attach_event_to_pagination_button()
{
    $("a.page-button").click(function(e){
        var a = $(this);
        num = $(".active.page.button").attr("data-value");
        page = parseInt(a.attr("data-value"));
        send_receive_detail_table_req();
        return false;
    });

    $("a#left-page").click(function(e){
        if($(this).attr("data-value") < page){
            page -= 1;
            num = $(".active.page.button").attr("data-value");
            send_receive_detail_table_req();
        }
    });

    $("a#right-page").click(function(e){
        if(page < $(this).attr("data-value")){
            page += 1;
            num = $(".active.page.button").attr("data-value");
            send_receive_detail_table_req();
        }
    });

    $(".clickable.page.button").click(function(e){
        var button = $(this);

        num = button.attr("data-value");
        page = 1;
        send_receive_detail_table_req();
        update_active_page_num_button(button);
    });
}

function update_active_pagination_button()
{
    $("a.page-button").removeClass("active");
    $("a.page-button[data-value=" + page + "]").addClass("active");
}

function send_receive_detail_table_req()
{
    var year = -1;
    var month = -1;
    var value = $('.ui.date.selection.dropdown').dropdown('get value');
    var match = value.match(/(\d+)年(\d+)月/);
    if(match){
        year = match[1];
        month = match[2];
    }
    var num = $(".active.page.button").attr("data-value");

    $('#table-loader').addClass("active");
    $.getJSON('/account/accounts',
			        {num: num,
               page: page,
               year: year,
               month: month
              },
              page_received);
}

function update_active_page_num_button(button)
{
    $(".page.button").removeClass("active");
    button.addClass("active");
}

function update_current_button_state()
{
    var match = value.match(/(\d+)年(\d+)月/);
    var year;
    var month;
    if(match){
        year = match[1];
        month = match[2];
    }
    var num = $(".active.page.button").attr("data-value");
}

$(function(){
    page = 1;

    send_receive_detail_table_req();

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

    $('.ui.date.selection.dropdown').dropdown({
		  	action:'activate',
		  	onChange:function(value, text, choice){
		  			send_receive_detail_table_req();
		  	}});
});
