import 'dart:html';
import 'package:google_charts/google_charts.dart';
import 'package:pcbuilder.api/domain/pricepointdata.dart';

/// Draw a price chart.
///
/// Create a price chart in element [lineChartElement] from [minDailyPrices]
/// and [maxDailyPrices].

drawPriceHistoryChart(List<PricePointData> minDailyPrices,
    List<PricePointData> maxDailyPrices, Element lineChartElement,
    {bool showTitle: true, String backgroundColor: '#f1f3f4'}) async {

  if (minDailyPrices != null && !minDailyPrices.isEmpty) {
    await Chart.load(packages: ['corechart'], language: "nl");
    var rawData = [
      ["Date", "Max", "Min"]
    ];

    for (int i = 0; i <= minDailyPrices.indexOf(minDailyPrices.last); i++) {
      PricePointData minDailyPrice = minDailyPrices.elementAt(i);
      PricePointData maxDailyPrice = maxDailyPrices.elementAt(i);
      rawData
          .add([minDailyPrice.date, maxDailyPrice.price, minDailyPrice.price]);
    }

    var data = arrayToDataTable(rawData, false);
    var chart = new LineChart(lineChartElement);

    var options = {
      'backgroundColor': backgroundColor,
      'vAxis': {'format': 'currency'},
      'series' : [
        {'color': '#9e3434'},
        {'color': '#349e34'}
      ]
    };

    if (showTitle) {
      options['title'] = 'Price History';
      options['hAxis'] = {'gridlines' : {'color' : '#c7d0d7'}};
      options['vAxis'] = {'gridlines' : {'color' : '#c7d0d7'}};
    } else {
      options['hAxis'] = {'textPosition': 'none', 'baselineColor': backgroundColor, 'gridlines' : {'color' : '#c3ccd3'}};
      options['vAxis'] = {'textPosition': 'none', 'baselineColor': backgroundColor, 'gridlines' : {'color' : '#c3ccd3'}};
      options['legend'] = {'position': 'none'};
    }
    chart.draw(data, options);
  }
}
