import 'dart:html';
import 'package:google_charts/google_charts.dart';
import 'package:pcbuilder.api/domain/pricepointdata.dart';

drawPriceHistoryChart(List<PricePointData> minDailyPrices, List<PricePointData> maxDailyPrices, Element lineChartElement) async {

  if (minDailyPrices!= null && !minDailyPrices.isEmpty) {

    await Chart.load(packages:['corechart'],language:"nl");
    var rawData = [["Date","Min","Max"]];

    for (int i = 0; i <= minDailyPrices.indexOf(minDailyPrices.last); i++) {
      PricePointData minDailyPrice = minDailyPrices.elementAt(i);
      PricePointData maxDailyPrice = maxDailyPrices.elementAt(i);
      rawData.add([
        new DateTime.fromMillisecondsSinceEpoch(minDailyPrice.date),
        minDailyPrice.price,
        maxDailyPrice.price
      ]);
    }

    var data = arrayToDataTable(rawData, false);
    var chart = new LineChart(lineChartElement);
    var options = {
      'title': 'Price History',
      'backgroundColor': '#f1f3f4',
      'vAxis': {'format': 'currency'}
    };
    chart.draw(data, options);
  }
}
