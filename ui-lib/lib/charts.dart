import 'dart:html';
import 'package:google_charts/google_charts.dart';
import 'package:pcbuilder.api/domain/pricepointdata.dart';

/// Draw a price chart.
///
/// Create a price chart in element [lineChartElement] from [minDailyPrices]
/// and [maxDailyPrices].

drawPriceHistoryChart(List<PricePointData> minDailyPrices,
    List<PricePointData> maxDailyPrices, Element lineChartElement,
    {bool showTitle: true}) async {

  if (minDailyPrices != null && !minDailyPrices.isEmpty) {
    await Chart.load(packages: ['corechart'], language: "nl");
    var rawData = [
      ["Date", "Min", "Max"]
    ];

    for (int i = 0; i <= minDailyPrices.indexOf(minDailyPrices.last); i++) {
      PricePointData minDailyPrice = minDailyPrices.elementAt(i);
      PricePointData maxDailyPrice = maxDailyPrices.elementAt(i);
      rawData
          .add([minDailyPrice.date, minDailyPrice.price, maxDailyPrice.price]);
    }

    var data = arrayToDataTable(rawData, false);
    var chart = new LineChart(lineChartElement);

    var options = {
      'backgroundColor': '#f1f3f4',
      'vAxis': {'format': 'currency'}
    };

    if (showTitle) {
      options['title'] = 'Price History';
    }
    chart.draw(data, options);
  }
}
