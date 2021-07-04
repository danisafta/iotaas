import 'package:admin/models/MyFiles.dart';
import 'package:admin/screens/main/components/bar_chart.dart';
import 'package:admin/screens/main/components/bar_chart_temperature.dart';
import 'package:admin/screens/main/components/combinational_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import '../../../constants.dart';

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

Future<List<RecentEvents>> fetchRecentEvents() async {
  var url = 'http://k8spi.go.ro:8080/events/stored/10';
  List nodes = [];
  var response;
  List<RecentEvents> sensors = [];

  for (var i = 0; i < demoMyFiles.length; i++) nodes.add(demoMyFiles[i].title);

  response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    List<dynamic> values = jsonDecode(response.body);
    for (var i = 0; i < 10; i++) {
      sensors.add(RecentEvents.fromJson(values[i]));
    }
  } else {
    // If the server did not return a 200 OK response,s
    // then throw an exception.
    throw Exception('Failed to load');
  }

  return sensors;
}

class RecentEvents {
  final dynamic node_name;
  final dynamic sensor_info;
  final dynamic date;
  final dynamic event_info;

  RecentEvents(
      {required this.node_name,
        required this.sensor_info,
        required this.date,
        required this.event_info});

  factory RecentEvents.fromJson(json) {
    return RecentEvents(
      node_name: json['node_name'],
      sensor_info: json['sensor_info'],
      date: json['date'],
      event_info: json['event_info'],
    );
  }
}

class RecentPlots extends StatefulWidget {
  RecentPlots({Key? key}) : super(key: key);

  @override
  _RecentPlotsState createState() => _RecentPlotsState();
}

class _RecentPlotsState extends State<RecentPlots>
    with SingleTickerProviderStateMixin {
  late Future<List<RecentSensor>> futureRecent;
  late Future<List<RecentHumidity>> futureRecentHumidity;
  late Future<List<RecentEvents>> futureRecentEvents;

  late TabController _controller;

  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(text: "Humidity"),
    Tab(text: "Temperature"),
    // Tab(text: "Measurements Overview"),
  ];

  @override
  void initState() {
    super.initState();
    futureRecent = fetchRecent();
    futureRecentHumidity = fetchRecentHumidity();
    futureRecentEvents = fetchRecentEvents();

    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      print("Selected index" + _controller.index.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Measurements",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          DefaultTabController(
            length: list.length, // length of tabs
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: TabBar(
                    onTap: (index) {},
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.white,
                    tabs: list,
                  ),
                ),
                Container(
                    height: 400, //height of TabBarView
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey, width: 0.5))),
                    child: TabBarView(children: [
                      MyBarChart(),
                      MyTemperatureBarChart(),
                      // CombinationalChart(),
                    ])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}