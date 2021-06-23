import 'package:flutter/material.dart';
import 'package:planaholic/services/DbService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:planaholic/util/PresetColors.dart';

/// activity count overview pie chart
class PieChartOverview extends StatefulWidget {
  const PieChartOverview({Key key}) : super(key: key);

  @override
  _PieChartOverviewState createState() => _PieChartOverviewState();
}

class _PieChartOverviewState extends State<PieChartOverview> {
  DbService _db = new DbService();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AspectRatio(
      // need to wrap this around Chart for sizing
      aspectRatio: 1,
      child: FutureBuilder(
        future: _db.getAllPassedEventCount(),
        builder: (context, snapshot) {
          Map data = {
            "Studies": 0,
            "Fitness": 0,
            "Arts": 0,
            "Social": 0,
            "Others": 0,
            "uncompleted": 0,
            "placeholder": 1,
          };

          if (snapshot.hasData) {
            data["placeholder"] = 0;
            snapshot.data.forEach((key, value) {
              data[key] = value;
            });
          }

          bool needsPlaceholder = true;
          data.values.forEach((element) {
            if (element != 0) {
              needsPlaceholder = false;
            }
          });
          if (needsPlaceholder) {
            data["placeholder"] = 1;
          }

          return PieChart(
            PieChartData(
              centerSpaceRadius: screenWidth * 0.12,
              sections: [
                // placeholder, loaded before other fields
                // such that non-blank pie chart is displayed
                makeSectionData("", data["placeholder"], showTitle: false),
                makeSectionData("Studies", data["Studies"], color: PresetColors.blue),
                makeSectionData("Fitness", data["Fitness"], color: PresetColors.purple),
                makeSectionData("Arts", data["Arts"], color: PresetColors.lightGreen),
                makeSectionData("Social", data["Social"], color: PresetColors.orangeAccent),
                makeSectionData("Others", data["Others"], color: PresetColors.red),
                makeSectionData("Uncompleted", data["uncompleted"]),
              ],
            ),
          );
        },
      ),
    );
  }

  PieChartSectionData makeSectionData(String category, int value,
      {Color color = Colors.grey, bool showTitle = true}) {
    double screenWidth = MediaQuery.of(context).size.width;
    return PieChartSectionData(
      title: category + "\n" + value.toString(),
      value: value * 1.0,
      showTitle: showTitle,
      radius: screenWidth * 0.28,
      color: color,
      titleStyle: TextStyle(fontSize: 15),
    );
  }
}
