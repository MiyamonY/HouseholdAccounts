function accounts_received(data, textStatus) {
    var plots = [];
    for(var i = 0; i < data.length; i++){
        var trace = {
	          x: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
	          y: data[i].amounts,
            name: data[i].year + "年",
            type: 'scatter'
        };
        plots[i] = trace;
    }
    var layout = {showlegend: true,
                  margin: {
                      l: 40,
                      r: 0,
                      b: 0,
                      t: 0,
                      pad: 4
                  },
	                legend: {"orientation": "h"}
                 };

	  Plotly.newPlot('plot', plots, layout);

};

$(function(){
    year = new Date().getFullYear()
    $.getJSON('/account/accounts',
			        {form: year,
               to:year},
              accounts_received
			       );
});
