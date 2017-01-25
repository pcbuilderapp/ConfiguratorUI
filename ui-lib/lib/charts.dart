import 'dart:html';
import 'dart:async';
import 'package:google_charts/google_charts.dart';
import 'package:pcbuilder.api/domain/pricepoint.dart';

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
