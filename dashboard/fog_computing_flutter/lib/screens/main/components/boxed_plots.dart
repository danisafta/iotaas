import 'package:admin/screens/main/components/area_chart.dart';
import 'package:admin/screens/main/components/combinational_chart.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:admin/models/MyFiles.dart';

import '../../../constants.dart';

class BoxedPlots extends StatefulWidget {
  BoxedPlots({Key? key}) : super(key: key);

  @override
  _BoxedPlotsState createState() => _BoxedPlotsState();
}

class _BoxedPlotsState extends State<BoxedPlots> {

  @override
  void initState() {
    super.initState();
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
                    "Measurements Overview",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: defaultPadding),
                  CombinationalChart(),
                  AreaChart(),
                ],
              ),
    );
  }
}