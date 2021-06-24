import 'package:flutter/cupertino.dart';
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

var x = 10;

Future<List<RecentSensor>> fetchRecent() async {
  var url = 'http://k8spi.go.ro:8080/temperature/stored/' + x.toString();
  List nodes = [];
  var response;
  List<RecentSensor> sensors = [];

  for (var i = 0; i < demoMyFiles.length; i++) nodes.add(demoMyFiles[i].title);

  response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    List<dynamic> values = jsonDecode(response.body);
    for (var i = 0; i < 10; i++) {
      sensors.add(RecentSensor.fromJson(values[i]));
    }
  } else {
    // If the server did not return a 200 OK response,s
    // then throw an exception.
    throw Exception('Failed to load');
  }

  return sensors;
}

class RecentSensor {
  final dynamic node_name;
  final dynamic sensor_info;
  final dynamic date;
  final dynamic value;

  RecentSensor(
      {required this.node_name,
        required this.sensor_info,
        required this.date,
        required this.value});

  factory RecentSensor.fromJson(json) {
    return RecentSensor(
      node_name: json['node_name'],
      sensor_info: json['sensor_info'],
      date: json['date'],
      value: json['value'],
    );
  }
}

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


class CombinationalChart extends StatefulWidget {
  @override
  _CombinationalChartState createState() => _CombinationalChartState();
}



class _CombinationalChartState extends State<CombinationalChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  late Future<List<RecentHumidity>> futureRecentHumidity;
  late Future<List<RecentSensor>> futureRecent;
  bool showAvg = false;

  @override
  void initState() {
    super.initState();
    futureRecentHumidity = fetchRecentHumidity();
    futureRecent = fetchRecent();
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
            child: FutureBuilder(
              future: Future.wait([
                futureRecentHumidity,
                futureRecent,
              ]),
              builder: (context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {

                  print(snapshot.data![0][0].sensor_info);
                  int len = 0;
                  len = snapshot.data![0].length;
                  List<RecentHumidity> humid = [];
                  List<RecentSensor> temp = [];
                  for (var i = 0; i < len; i++) {
                    humid.add(RecentHumidity(
                        sensor_info: snapshot.data![0][i].sensor_info,
                        node_name: snapshot.data![0][i].node_name,
                        date: snapshot.data![0][i].date,
                        value: snapshot.data![0][i].value));

                    temp.add(RecentSensor(
                        sensor_info: snapshot.data![1][i].sensor_info,
                        node_name: snapshot.data![1][i].node_name,
                        date: snapshot.data![1][i].date,
                        value: snapshot.data![1][i].value));

                    print(snapshot.data![0][i].value);
                    print(snapshot.data![1][i].value);
                  }


                  // List<charts.Series<RecentHumidity, String>> series = [
                  //   charts.Series(
                  //     id: "RecentHumidity",
                  //     data: humid,
                  //     domainFn: (RecentHumidity series, _) => series.date.substring(17,22),
                  //     measureFn: (RecentHumidity series, _) => series.value,
                  //     colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                  //   )
                  // ];


                  return Container(
                      height: 400,
                      padding: EdgeInsets.all(20),
                      child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                      Expanded(
                        flex: 5,
                        child: Center(
                          child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),

                              title: ChartTitle(text: 'Overview'),
                              // Enable legend
                              legend: Legend(isVisible: true),
                              // Enable tooltip
                              tooltipBehavior: TooltipBehavior(enable: true),

                                series: <CartesianSeries>[
                                  // Render column series
                                  ColumnSeries<RecentHumidity, String>(
                                    dataSource: humid,
                                    xValueMapper: (RecentHumidity data, _) => data.date.substring(17, 22),
                                    yValueMapper: (RecentHumidity data, _) => data.value,
                                    name: 'Humidity',
                dataLabelSettings: DataLabelSettings(isVisible: true)
                                  ),
                                  // Render line series
                                  ColumnSeries<RecentSensor, String>(
                                      dataSource: temp,
                                      xValueMapper: (RecentSensor data, _) => data.date.substring(17, 22),
                                      yValueMapper: (RecentSensor data, _) => data.value,
                                    name: 'Temperature',
                dataLabelSettings: DataLabelSettings(isVisible: true)
                                  ),
                                ]
                            ),
                        ),
                      )



                        //Initialize the chart widget
                        // SfCartesianChart(
                        //     primaryXAxis: CategoryAxis(),
                        //     // Chart title
                        //     title: ChartTitle(text: 'Recent Humidity Measurements'),
                        //     // Enable legend
                        //     legend: Legend(isVisible: true),
                        //     // Enable tooltip
                        //     tooltipBehavior: TooltipBehavior(enable: true),
                        //     series: <ChartSeries<RecentHumidity, String>>[
                        //       LineSeries<RecentHumidity, String>(
                        //           dataSource: humid,
                        //           xValueMapper: (RecentHumidity sales, _) => sales.date.substring(17, 22),
                        //           yValueMapper: (RecentHumidity sales, _) => sales.value,
                        //           name: 'Humidity',
                        //           // Enable data label
                        //           dataLabelSettings: DataLabelSettings(isVisible: true))
                        //     ]),
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