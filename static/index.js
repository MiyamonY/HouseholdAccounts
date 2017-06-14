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

function breakdown_received(data, textStatus){
    var labels = [];
    var values = [];

    for(label in data){
        labels.push(label);
        values.push(data[label]);
    }

    var plots = [{
        values: values,
        labels: labels,
        hole:.4,
        type: 'pie'
    }];
    var layout =
        {annotations: [{
            text: "2017年",
            showarrow:false}],
         margin: {
             l: 40,
             r: 0,
             b: 0,
             t: 0,
             pad: 4
         },
         showlegend: true,
	       legend: {"orientation": "h"}
        };

    Plotly.newPlot('plot2', plots, layout);
}

$(function(){
    year = new Date().getFullYear();

    $.getJSON('/account/accounts/sum',
			        {form: 2017,
               to:year},
              accounts_received
			       );

    $.getJSON('/account/breakdown',
              {year:year},
              breakdown_received
             );

});
