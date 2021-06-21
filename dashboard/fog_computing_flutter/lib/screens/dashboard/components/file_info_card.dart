import 'package:admin/models/MyFiles.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

Future<List<NodeDetails>> fetchDetails() async {
  var url = 'http://161.35.92.58:5000/nodes';
  List nodes = [];
  var response;
  List<NodeDetails> details = [];

  for (var i = 0; i < demoMyFiles.length; i++) nodes.add(demoMyFiles[i].title);

  response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    List<dynamic> values = jsonDecode(response.body);

    for (var i = 0; i < values.length; i++) {
      details.add(NodeDetails.fromJson(values[i]));
      print(details[i].node_name);
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

  NodeDetails(
      {required this.apps,
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

class FileInfoCard extends StatefulWidget {
  FileInfoCard({Key? key, required this.info}) : super(key: key);
  final CloudStorageInfo info;

  @override
  _FileInfoCardState createState() => _FileInfoCardState(info);
}

class _FileInfoCardState extends State<FileInfoCard> {
  late Future<List<NodeDetails>> futureDetails;
  CloudStorageInfo cloud;
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
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder<List<NodeDetails>>(
                future: futureDetails,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    int len = 0;
                    len = snapshot.data!.length;
                    NodeDetails? data = null;
                    for (var i = 0; i < len; i++) {
                      if(this.cloud.subtitle == snapshot.data![i].node_name) {
                        data = NodeDetails(
                          apps: snapshot.data![i].apps,
                          arch: snapshot.data![i].arch,
                          control_plane: snapshot.data![i].control_plane,
                          etcd: snapshot.data![i].etcd,
                          ip: snapshot.data![i].ip,
                          master: snapshot.data![i].master,
                          node_name: snapshot.data![i].node_name,
                          os: snapshot.data![i].os,
                        );
                      }
                    }

                      return Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:
                              [
                                Center(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(defaultPadding * 0.75),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: cloud.color!.withOpacity(0.1),
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: SvgPicture.asset(
                                          cloud.svgSrc!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text("Node Name: "  + data!.node_name, textAlign: TextAlign.center),
                                Text("IP address: " + data!.ip, textAlign: TextAlign.center),
                                Text("Architecture: " + data!.arch, textAlign: TextAlign.center),
                                Text("Operating System: " + data!.os, textAlign: TextAlign.center),
                  ]
                        ),
                      );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                }),
          ],
        ),
      ),
    );
  }

  _FileInfoCardState(this.cloud);
}
