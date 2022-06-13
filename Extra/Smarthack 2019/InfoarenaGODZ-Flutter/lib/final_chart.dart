import 'package:flutter/material.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';
import 'package:intl/intl.dart';

class FinalData {
  FinalData(this.rating, this.price);
  final String rating;
  final double price;
} // chart point data

class FinalChart extends StatefulWidget {
  FinalChart(String name, String code, {Key key}): _name = name, _code = code, super(key: key);

  final String _name;
  final String _code;

  @override
  _FinalChartState createState() => _FinalChartState();
}

class _FinalChartState extends State < FinalChart > {

  List < FinalData > _data = [];

  @override
  initState() {
    super.initState();
    updateChartData();
    // init the influence x price chart
  }

  @override
  Widget build(BuildContext context) {
    if (_data.length != 0) {
      /*return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(text: 'Influence of tweets and news'),
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryYAxis: NumericAxis(
          numberFormat: NumberFormat.simpleCurrency()
        ),
        series: < ChartSeries >[
          LineSeries < FinalData, String >(
            dataSource: _data,
            xValueMapper: (FinalData element, _) => element.rating,
            yValueMapper: (FinalData element, _) => element.price,
            color: Colors.red,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          )
        ],
      );*/
      return Container();
    } // display chart if there is data available
    return Container(); // display nothing otherwise
  }

  void updateChartData() {
    if(_data.length==0) {
      fetchChartDataX().then((chartData) {
        setState(() {
          _data = chartData;
        });
      });
    }
  } // update chard data

  Future < List < FinalData > > fetchChartDataX() async {
    final response = await http.get(BASE_IP_FINAL_DATA + widget._name + "/" + widget._code);
    final decodedResponse = json.decode(response.body);

    var xPoints = List < double >.from(decodedResponse["rating"]);
    var yPoints = List < double >.from(decodedResponse["stock"]);

    List < FinalData > ret = [];
    for (int i = 0; i < xPoints.length; ++ i) {
      ret.add(FinalData(xPoints[i].toStringAsFixed(2), yPoints[i].toDouble()));
    }

    return ret;
  } // request and parse data for chart
}
