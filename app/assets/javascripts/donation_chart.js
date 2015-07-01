$.ajax({
    url: '/plaid/donations_graph',
    type: 'GET'
}).done(function(response){
  var cumulative_donation_array = response['monthAmount']['cumulative_donation'];
  var daily_donation_array = response['monthAmount']['daily_donation'];

  for(var x = 0; x < cumulative_donation_array.length; x++){
    cumulative_donation_array[x] = parseFloat(cumulative_donation_array[x]);
  };
  for(var x = 0; x < daily_donation_array.length; x++){
    daily_donation_array[x] = parseFloat(daily_donation_array[x]);
  };

  Highcharts.setOptions({
      colors: ['#24CBE5'],
      // colors: ['#6AF9C4']
  });

  $('#chart-container').highcharts({
    chart: {
      // Sets the type of font
      type: 'area',

      // Sets the background color
      // backgroundColor: '#6AF9C4',

      // Sets the margins
      marginTop: 20,
      marginRight: 20,
      marginLeft: 20,
      marginBottom: 20,

      // Sets the angle curves
      borderRadius: 5,

      // Sets the font
      // style: {
      //     fontFamily: 'serif'
      // }
    },
    tooltip:{
      shared: true,
      formatter: function(){
        var s = '<b>' + this.x + '</b>' + '<br/>Tot: $' + this.points[0].y + '<br/>Day: $' + this.points[1].y


        return s;
      }
    },

    // plotOptions: {
    //   // line: {
    //   //  lineWidth: 0
    //   // }
    // },
    title: {
        text: 'Contributions'
    },
    xAxis: {
      categories: response['monthAmount']['dates'],

      // Gets rid of X-Axis line
      lineWidth: 0,
      gridLineWidth: 0,
      tickWidth: 0,
      labels: {
          enabled: false
      }
    },
    yAxis: [
      {
        title: {
          text: null
        },
        labels: {
          align: 'left',
          enabled: false,
          x: 0,
          y: -2,
        },
        // Removes Y-Axis line
        gridLineWidth: 0,
        max: response['monthAmount']['cumulative_donation'][response['monthAmount']['cumulative_donation'].length - 1]
      },
      {
        title: {
          text: null
        },
        labels: {
          align: 'right',
          enabled: false,
          x: 0,
          y: -2
        },
        // Removes Y-Axis line
        gridLineWidth: 0,
        max: 7.5
      }
    ],
    series: [
      {
        showInLegend: false,
        data: response['monthAmount']['cumulative_donation'],
        name: "Tot",
        yAxis: 0,
        color: 'rgba(3,169,244,1)'
      },
      {
        showInLegend: false,
        data: response['monthAmount']['daily_donation'],
        name: "Day",
        yAxis: 1,
        color: 'rgba(55,127,58,0.25)',
        fillColor: 'rgba(0,0,0,0)'
      }
    ]
  });
}).fail(function(response){
       console.log('Request Failed. Response below: \n' + MonthAmount);
    });





// light blue: '#24CBE5'
// light green: '#6AF9C4'

// function getMonthAmount(){

//     var request =
// }
