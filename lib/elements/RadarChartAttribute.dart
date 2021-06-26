import 'package:flutter/material.dart';
import 'package:planaholic/services/DbService.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

/// weekly overview bar chart
class RadarChartAttribute extends StatefulWidget {
  const RadarChartAttribute({Key key}) : super(key: key);

  @override
  _RadarChartAttributeState createState() => _RadarChartAttributeState();
}

class _RadarChartAttributeState extends State<RadarChartAttribute> {

  var ticks = List<int>.generate(10, (int index) => (index + 1) * 10);
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
        Map data = {
              "Vitality": 50,
              "Spirit": 50,
              "Charm": 50,
              "Resolve": 50,
              "Intelligence": 50,
            };
        if (snapshot.hasData) {
          snapshot.data.forEach((key, value) {
            data[key] = (value / 10).round();
          });
        }

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