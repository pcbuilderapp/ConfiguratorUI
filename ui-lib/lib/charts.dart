import 'dart:html';
import 'package:google_charts/google_charts.dart';
import 'package:pcbuilder.api/domain/pricepoint.dart';

drawLineChart(List<PricePoint> pricePoints, Element lineChartElement) {

  LineChart.load().then((_) {
    var rawData = [["Date","Price"]];
    for (PricePoint pricePoint in pricePoints) {
      rawData.add([new DateTime.fromMillisecondsSinceEpoch(pricePoint.pricingDate), pricePoint.price]);
    }
    var data = arrayToDataTable(rawData, false);
    var chart = new LineChart(lineChartElement);
    var options = {'title': 'Price History','backgroundColor': '#f1f3f4'};
    chart.draw(data, options);
  });
}
