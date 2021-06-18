import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:plannus/services/DbService.dart';
import 'package:plannus/util/PresetColors.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

/// weekly overview bar chart
class RadarChartAttribute extends StatefulWidget {
  const RadarChartAttribute({Key key}) : super(key: key);

  @override
  _RadarChartAttributeState createState() => _RadarChartAttributeState();
}

class _RadarChartAttributeState extends State<RadarChartAttribute> {

  var ticks = List<int>.generate(10, (int index) => (index + 1) * 100);
  var features = [
    "Charm",
    "Resolve",
    "Intelligence",
    "Vitality",
    "Spirit",
  ];

  DbService _db = new DbService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _db.getUserAttributes(),
      builder: (context, snapshot) {
        Map data = snapshot.hasData
            ? snapshot.data
            : {
              "Vitality": 500,
              "Spirit": 500,
              "Charm": 500,
              "Resolve": 500,
              "Intelligence": 500,
            };
        List<int> dataInside = [];
        for (String x in features) {
          dataInside.add(data[x]);
        }
        var dataList = [dataInside];
        return RadarChart.light(
          ticks: ticks,
          features: features,
          data: dataList,
          reverseAxis: false,
          useSides: false,
        );
      }
    );
  }
}