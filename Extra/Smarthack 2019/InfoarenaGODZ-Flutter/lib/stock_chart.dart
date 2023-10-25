import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';
import 'package:intl/intl.dart';

class StockData {
  StockData(this.date, this.price);
  final String date;
  final double price;
}

class StockChart extends StatefulWidget {
  StockChart(String code, {Key key}): _code = code, super(key: key);

  final String _code;

  @override
  _StockChartState createState() => _StockChartState();
}

class _StockChartState extends State < StockChart > {

  List < StockData > _data = [];

  @override
  initState() {
    super.initState();
    updateChartData();
  }

  @override
  Widget build(BuildContext context) {
    /*if(_data.length!=0){
      return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(text: 'One month stock analysis'),
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.simpleCurrency()
        ),
        series: < ChartSeries >[
          LineSeries < StockData, String >(
            dataSource: _data,
            xValueMapper: (StockData stock, _) => stock.date,
            yValueMapper: (StockData stock, _) => stock.price,
            dataLabelSettings: DataLabelSettings(isVisible: true)
          )
        ],
      );
    }*/
    return Container();
  }

  void updateChartData() {
    if(_data.length==0){
      fetchChartDataX().then((chartData) {
        setState(() {
          _data = chartData;
        });
      });
    }
  }

  Future < List < StockData > > fetchChartDataX() async {
    final response = await http.get(BASE_IP_STOCKS + widget._code);
    final decodedResponse = json.decode(response.body);

    var xPoints = List < int >.from(decodedResponse["dates"]);
    var yPoints = List < double >.from(decodedResponse["prices"]);

    List < StockData > ret = [];
    for (int i = 0; i < xPoints.length; ++ i) {
      ret.add(StockData(xPoints[i].toString() + " Oct.", yPoints[i].toDouble()));
    }

    return ret;
  }
}
