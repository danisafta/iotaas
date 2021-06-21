import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'my_chart.dart';
import 'storage_info_card.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:admin/models/MyFiles.dart';

import '../../../constants.dart';

Future<List<NodeDetails>> fetchDetails() async {
  var url = 'http://161.35.92.58:5000/nodes';
  List nodes = [];
  var response;
  List<NodeDetails> details = [];

  for (var i = 0; i < demoMyFiles.length; i++)
    nodes.add(demoMyFiles[i].title);

  response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    List<dynamic> values = jsonDecode(response.body);

    for (var i = 0; i < values.length; i++) {
      details.add(NodeDetails.fromJson(values[i]));
    }
  } else {
    // If the server did not return a 200 OK response,s
    // then throw an exception.
    throw Exception('Failed to load');
  }

  return details;
}

class NodeDetails {
  final dynamic apps;
  final dynamic arch;
  final dynamic control_plane;
  final dynamic etcd;
  final dynamic ip;
  final dynamic master;
  final dynamic node_name;
  final dynamic os;

  NodeDetails({required this.apps,
    required this.arch,
    required this.control_plane,
    required this.etcd,
    required this.ip,
    required this.master,
    required this.node_name,
    required this.os});

  factory NodeDetails.fromJson(json) {
    return NodeDetails(
      apps: json['apps'],
      arch: json['arch'],
      control_plane: json['control-plane'],
      etcd: json['etcd'],
      ip: json['ip'],
      master: json['master'],
      node_name: json['node_name'],
      os: json['os'],
    );
  }
}

class StorageDetails extends StatefulWidget {
  StorageDetails({Key? key}) : super(key: key);

  @override
  _StorageDetailsState createState() => _StorageDetailsState();
}

class _StorageDetailsState extends State<StorageDetails> {
  late Future<List<NodeDetails>> futureDetails;

  @override
  void initState() {
    super.initState();
    futureDetails = fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: FutureBuilder<List<NodeDetails>>(
          future: futureDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              int len = 0;
              len = snapshot.data!.length;
              List<NodeDetails> data = [];
              for (var i = 0; i < len; i++) {
                data.add(NodeDetails(
                  apps: snapshot.data![i].apps,
                  arch: snapshot.data![i].arch,
                  control_plane: snapshot.data![i].control_plane,
                  etcd: snapshot.data![i].etcd,
                  ip: snapshot.data![i].ip,
                  master: snapshot.data![i].master,
                  node_name: snapshot.data![i].node_name,
                  os: snapshot.data![i].os,
                ));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Running Applications Overview",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: defaultPadding),
                  MyChart(),
                  StorageInfoCard(
                    svgSrc: "assets/icons/raspberry.svg",
                    title: "MASTER1",
                    numOfApps: data[0].apps,
                  ),
                  StorageInfoCard(
                    svgSrc: "assets/icons/raspberry.svg",
                    title: "WORKER1",
                    numOfApps: data[1].apps,
                  ),
                  StorageInfoCard(
                    svgSrc: "assets/icons/raspberry.svg",
                    title: "WORKER2",
                    numOfApps: data[2].apps,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          }
      ),
    );
  }
}