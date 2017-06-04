$(function(){
    var trace1 = {
	      x: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
	      y: [1, 12, 3, 4, 16, 2, 3, 4, 10, 12, 3],
        name: '2017年',
        type: 'scatter'
    };
    var trace2 = {
        x: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
	      y: [1, 12, 3, 4, 16, 2, 3, 4, 10, 12, 3],
        name: '2016年',
        type: 'scatter'

    };
    var layout = {showlegend: true,
	                legend: {"orientation": "h"}};
	  Plotly.newPlot('plot', [trace1, trace2], layout);
});
