import 'package:admin/models/MyFiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

import '../../../responsive.dart';



Future<List<RecentEvents>> fetchRecentEvents() async {
  var url = 'http://k8spi.go.ro:8080/events/stored/10';
  List nodes = [];
  var response;
  List<RecentEvents> sensors = [];

  for (var i = 0; i < demoMyFiles.length; i++) nodes.add(demoMyFiles[i].title);

  var state;
  response = await http.post(Uri.parse(url), body: jsonEncode(<String, String>{
    'state': state,
  }),);
  if (response.statusCode == 201) {
    // List<dynamic> values = jsonDecode(response.body);
    // for (var i = 0; i < 10; i++) {
    //   sensors.add(RecentEvents.fromJson(values[i]));
    // }

    return response.statusCode;
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





class MyActions extends StatefulWidget {
  MyActions({Key? key}) : super(key: key);

  @override
  _MyActionsState createState() => _MyActionsState();
}

class _MyActionsState extends State<MyActions> {

  @override
  void initState() {
    super.initState();
  }

  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: secondaryColor,
      ),

      home: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
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
          child: Column(
            children:[
              CupertinoSwitch(
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;

                });
              },
            ),
              Text("Open/Close the window", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white)),
          ],
          ),
        ),
      ),
    );

  }
}