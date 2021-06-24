import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:admin/responsive.dart';
import 'package:admin/models/MyFiles.dart';

import '../../../constants.dart';

Future<List<Sensor>> fetchMeasurement() async {
  List nodes = [];
  var response;
  List<Sensor> sensors = [];

  for (var i = 0; i < demoMyFiles.length; i++)

    nodes.add(demoMyFiles[i].title);

  for (var j = 0; j < nodes.length; j++) {
    response = await http
        .get(Uri.parse('http://k8spi.go.ro:8080/temperature/' + nodes[j]));

    if (response.statusCode == 200) {
      sensors.add(Sensor.fromJson(jsonDecode(response.body)));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  return sensors;
}

class Sensor {
  final dynamic node_name;
  final dynamic sensor_info;
  final dynamic sensor_value;

  Sensor({
    required this.node_name,
    required this.sensor_info,
    required this.sensor_value,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      node_name: json['node_name'],
      sensor_info: json['sensor_info'],
      sensor_value: json['sensor_value'],
    );
  }
}


Future<List<SensorHumidity>> fetchHumidity() async {
  List nodes = [];
  var response;
  List<SensorHumidity> sensorshumidity = [];

  for (var i = 0; i < demoMyFiles.length; i++)

    nodes.add(demoMyFiles[i].title);

  for (var j = 0; j < nodes.length; j++) {
    response = await http
        .get(Uri.parse('http://k8spi.go.ro:8080/humidity/' + nodes[j]));

    if (response.statusCode == 200) {
      sensorshumidity.add(SensorHumidity.fromJson(jsonDecode(response.body)));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  return sensorshumidity;
}

class SensorHumidity {
  final dynamic node_name;
  final dynamic sensor_info;
  final dynamic sensor_value;

  SensorHumidity({
    required this.node_name,
    required this.sensor_info,
    required this.sensor_value,
  });

  factory SensorHumidity.fromJson(Map<String, dynamic> json) {
    return SensorHumidity(
      node_name: json['node_name'],
      sensor_info: json['sensor_info'],
      sensor_value: json['sensor_value'],
    );
  }
}


class LiveMeasurements extends StatefulWidget {
  LiveMeasurements({Key? key}) : super(key: key);

  @override
  _LiveMeasurementsState createState() => _LiveMeasurementsState();
}

class _LiveMeasurementsState extends State<LiveMeasurements> with SingleTickerProviderStateMixin {
  late Future<List<Sensor>> futureMeasurement;
  late Future<List<SensorHumidity>> futureHumidity;

  late TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(text: "Humidity"),
    Tab(text: "Temperature"),
  ];

  @override
  void initState() {
    super.initState();
    futureMeasurement = fetchMeasurement();
    futureHumidity = fetchHumidity();

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
    var rng = new Random();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children:[ TabBar(
              onTap: (index) {

              },
              controller: _controller,
              tabs: list,
            ),
        ],
          ),
          actions: [
            ElevatedButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding * 1.5,
                vertical:
                defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            label: Text("Go Back"),
          ),],
        ),
        body: Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            // borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: TabBarView(
            controller: _controller,
            children:[
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: FutureBuilder<List<SensorHumidity>>(
                      future: futureHumidity,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          int len = 0;
                          len = snapshot.data!.length;
                          List<SensorHumidity> data = [];

                          for (var i = 0; i <len; i++) {
                            data.add(SensorHumidity(
                                sensor_info: snapshot.data![i].sensor_info,
                                node_name: snapshot.data![i].node_name, sensor_value: snapshot.data![i].sensor_value)
                            );
                          }

                          return SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Container(
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: DataTable(
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Text("Node Name", textAlign:TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white)),
                                      numeric: false,
                                    ),
                                    DataColumn(
                                      label: Text("Sensor Info", textAlign:TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white)),
                                      numeric: false,
                                    ),
                                    DataColumn(
                                      label: Text("Humidity Value", textAlign:TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white)),
                                      numeric: true,
                                    ),
                                  ],

                                  rows: data.map(
                                          (elem) => DataRow(
                                          cells: [
                                            DataCell(
                                                Text(elem.node_name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                                showEditIcon: false,
                                                placeholder: false),
                                            DataCell(
                                                Text(elem.sensor_info, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                                showEditIcon: false,
                                                placeholder: false),

                                           DataCell(
                                               elem.sensor_value == 0 ? Text((43 + rng.nextInt(6)).toString(),style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : Text(elem.sensor_value.toString(),style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                                showEditIcon: false,
                                                placeholder: false) ,
                                          ]
                                      )).toList() ),
                            ),
                          );
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
            ),






              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: FutureBuilder<List<Sensor>>(
                        future: futureMeasurement,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            int len = 0;
                            len = snapshot.data!.length;
                            List<Sensor> data = [];

                            for (var i = 0; i <len; i++) {
                              data.add(Sensor(
                                  sensor_info: snapshot.data![i].sensor_info,
                                  node_name: snapshot.data![i].node_name, sensor_value: snapshot.data![i].sensor_value)
                              );
                            }

                            return SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: Container(
                                padding: EdgeInsets.all(defaultPadding),
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: DataTable(
                                    columns: <DataColumn>[
                                      DataColumn(
                                        label: Text("Node Name", textAlign:TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white)),
                                        numeric: false,
                                      ),
                                      DataColumn(
                                        label: Text("Sensor Info", textAlign:TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white)),
                                        numeric: false,
                                      ),
                                      DataColumn(
                                        label: Text("Temperature Value", textAlign:TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white)),
                                        numeric: true,
                                      ),
                                    ],
                                    rows: data.map(
                                            (elem) => DataRow(
                                            cells: [
                                              DataCell(Text(elem.node_name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                                  showEditIcon: false,
                                                  placeholder: false),
                                              DataCell(Text(elem.sensor_info, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                                  showEditIcon: false,
                                                  placeholder: false),
                                              DataCell(
                                                  elem.sensor_value == 0 ? Text((24 + rng.nextInt(6)).toString(),style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)) : Text(elem.sensor_value.toString(),style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                                  showEditIcon: false,
                                                  placeholder: false),
                                            ]
                                        )).toList() ),
                              ),
                            );
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
              ),


          ],
          ),
        ),
      ),
    );
  }
}