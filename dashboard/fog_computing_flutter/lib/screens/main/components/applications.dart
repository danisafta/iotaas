import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

import '../../../responsive.dart';

Future<List<AppDetails>> fetchApps() async {
  var url = 'http://161.35.92.58:5000/apps';
  List nodes = [];
  var response;
  List<AppDetails> apps = [];

  response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    List<dynamic> values = jsonDecode(response.body);

    for (var i = 0; i < values.length; i++) {
      apps.add(AppDetails.fromJson(values[i]));

      // print(values[i]);
    }
  } else {
    // If the server did not return a 200 OK response,s
    // then throw an exception.
    throw Exception('Failed to load');
  }

  return apps;
}

class AppDetails {
  final dynamic app_name;
  final dynamic namespace;
  final dynamic node_name;

  AppDetails(
      {required this.app_name,
      required this.namespace,
      required this.node_name});

  factory AppDetails.fromJson(json) {
    return AppDetails(
      app_name: json['app_name'],
      namespace: json['namespace'],
      node_name: json['node_name'],
    );
  }
}

class Applications extends StatefulWidget {
  Applications({Key? key}) : super(key: key);

  @override
  _ApplicationsState createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications>
    with SingleTickerProviderStateMixin {
  late Future<List<AppDetails>> futureApps;

  @override
  void initState() {
    super.initState();
    futureApps = fetchApps();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Applications"),

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Running Applications",
              //   style: Theme.of(context).textTheme.subtitle1,
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 400, //height of TabBarView
                    // decoration: BoxDecoration(
                    //     border: Border(
                    //         top: BorderSide(color: Colors.grey, width: 0.5))),
                    child: SizedBox(
                        width: double.infinity,
                        child: FutureBuilder<List<AppDetails>>(
                          future: futureApps,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              int len = 0;
                              len = snapshot.data!.length;

                              List<AppDetails> data = [];
                              for (var i = 0; i < len; i++) {
                                data.add(AppDetails(
                                    app_name: snapshot.data![i].app_name,
                                    namespace: snapshot.data![i].namespace,
                                    node_name: snapshot.data![i].node_name));
                              }
                              return Container(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    horizontalMargin: 0,
                                    columnSpacing: defaultPadding,
                                    columns: [
                                      DataColumn(
                                        label: Text("App Name", textAlign:TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      DataColumn(
                                        label: Text("Namespace", textAlign:TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      DataColumn(
                                        label: Text("Node Name", textAlign:TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                    rows: data
                                        .map((elem) => DataRow(cells: [
                                              DataCell(
                                                Text(elem.app_name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                                showEditIcon: false,
                                                placeholder: false,
                                              ),
                                              DataCell(Text(elem.namespace, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                                  showEditIcon: false,
                                                  placeholder: false),
                                              DataCell(Text(elem.node_name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                                  showEditIcon: false,
                                                  placeholder: false),
                                            ]))
                                        .toList(),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }

                            // By default, show a loading spinner.
                            return Container(
                              alignment: Alignment.center,
                                child: CircularProgressIndicator());
                          },
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
