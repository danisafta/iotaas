import 'package:flutter/material.dart';
import 'package:admin/models/MyFiles.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import '../../../constants.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';


Future<List<RecentHumidity>> fetchRecentHumidity() async {
  var url = 'http://k8spi.go.ro:8080/humidity/stored/10';
  List nodes = [];
  var response;
  List<RecentHumidity> sensors = [];

  for (var i = 0; i < demoMyFiles.length; i++) nodes.add(demoMyFiles[i].title);

  response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    List<dynamic> values = jsonDecode(response.body);
    for (var i = 0; i < 10; i++) {
      sensors.add(RecentHumidity.fromJson(values[i]));
    }
  } else {
    // If the server did not return a 200 OK response,s
    // then throw an exception.
    throw Exception('Failed to load');
  }

  return sensors;
}

class RecentHumidity {
  final dynamic node_name;
  final dynamic sensor_info;
  final dynamic date;
  final dynamic value;

  RecentHumidity(
      {required this.node_name,
        required this.sensor_info,
        required this.date,
        required this.value});

  factory RecentHumidity.fromJson(json) {
    return RecentHumidity(
      node_name: json['node_name'],
      sensor_info: json['sensor_info'],
      date: json['date'],
      value: json['value'],
    );
  }
}

class MyBarChart extends StatefulWidget {
  @override
  _MyBarChartState createState() => _MyBarChartState();
}

class _MyBarChartState extends State<MyBarChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  late Future<List<RecentHumidity>> futureRecentHumidity;
  bool showAvg = false;

  @override
  void initState() {
    super.initState();
    futureRecentHumidity = fetchRecentHumidity();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                color: secondaryColor),
            child: FutureBuilder<List<RecentHumidity>>(
              future: futureRecentHumidity,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int len = 0;
                  len = snapshot.data!.length;
                  List<RecentHumidity> data = [];
                  for (var i = 0; i < len; i++) {
                    data.add(RecentHumidity(
                        sensor_info: snapshot.data![i].sensor_info,
                        node_name: snapshot.data![i].node_name,
                        date: snapshot.data![i].date,
                        value: snapshot.data![i].value));
                  }


                  // List<charts.Series<RecentHumidity, String>> series = [
                  //   charts.Series(
                  //     id: "RecentHumidity",
                  //     data: data,
                  //     domainFn: (RecentHumidity series, _) => series.date.substring(17,22),
                  //     measureFn: (RecentHumidity series, _) => series.value,
                  //     colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                  //   )
                  // ];
                  return Container(
                    height: 400,
                    padding: EdgeInsets.all(20),
                     child:Column(children: [
                       //Initialize the chart widget
                       SfCartesianChart(
                           primaryXAxis: CategoryAxis(),
                           // Chart title
                           title: ChartTitle(text: 'Recent Humidity Measurements'),
                           // Enable legend
                           legend: Legend(isVisible: true),
                           // Enable tooltip
                           tooltipBehavior: TooltipBehavior(enable: true),
                           series: <ChartSeries<RecentHumidity, String>>[
                             LineSeries<RecentHumidity, String>(
                                 dataSource: data,
                                 xValueMapper: (RecentHumidity sales, _) => sales.date.substring(17, 22),
                                 yValueMapper: (RecentHumidity sales, _) => sales.value,
                                 name: 'Humidity',
                                 // Enable data label
                                 dataLabelSettings: DataLabelSettings(isVisible: true))
                           ]),
                       Expanded(
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           //Initialize the spark charts widget
                           child: SfSparkLineChart.custom(
                             //Enable the trackball
                             trackball: SparkChartTrackball(
                                 activationMode: SparkChartActivationMode.tap),
                             //Enable marker
                             marker: SparkChartMarker(
                                 displayMode: SparkChartMarkerDisplayMode.all),
                             //Enable data label
                             labelDisplayMode: SparkChartLabelDisplayMode.all,
                             xValueMapper: (int index) => data[index].date.substring(17, 22),
                             yValueMapper: (int index) => data[index].value,
                             dataCount: 5,
                           ),
                         ),
                       )
                     ]));

                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ],
    );
  }
}