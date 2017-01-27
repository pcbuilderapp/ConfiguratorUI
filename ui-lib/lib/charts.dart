import 'dart:html';
import 'package:google_charts/google_charts.dart';
import 'package:pcbuilder.api/domain/pricepoint.dart';
import 'package:pcbuilder.api/domain/maxdailypriceview.dart';

drawLineChart(List<PricePoint> pricePoints, Element lineChartElement) async {

  await Chart.load(packages:['corechart'],language:"nl");
  var rawData = [["Date","Price"]];

  for (PricePoint pricePoint in pricePoints) {
    rawData.add([new DateTime.fromMillisecondsSinceEpoch(pricePoint.pricingDate), pricePoint.price]);
  }

  var data = arrayToDataTable(rawData, false);
  var chart = new LineChart(lineChartElement);
  var options = {'title': 'Price History','backgroundColor': '#f1f3f4','vAxis':{'format':'currency'}};
  chart.draw(data, options);
}

drawLineChartMinDaily(List<DailyPriceView> minDailyPrices, List<DailyPriceView> maxDailyPrices, Element lineChartElement) async {

  await Chart.load(packages:['corechart'],language:"nl");
  var rawData = [["Date","Min","Max"]];

  for (int i = 0; i <= minDailyPrices.indexOf(minDailyPrices.last); i++) {
    DailyPriceView minDailyPrice = minDailyPrices.elementAt(i);
    DailyPriceView maxDailyPrice = maxDailyPrices.elementAt(i);
    rawData.add([new DateTime.fromMillisecondsSinceEpoch(minDailyPrice.date), minDailyPrice.price, maxDailyPrice.price]);
  }

  var data = arrayToDataTable(rawData, false);
  var chart = new LineChart(lineChartElement);
  var options = {'title': 'Price History','backgroundColor': '#f1f3f4','vAxis':{'format':'currency'}};
  chart.draw(data, options);
}
