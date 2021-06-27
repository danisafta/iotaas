import 'package:admin/responsive.dart';
import 'package:admin/screens/main/components/boxed_plots.dart';
import 'package:admin/screens/main/components/combinational_chart.dart';
import 'package:admin/screens/main/components/recent_plots.dart';
import 'package:admin/screens/main/components/statistics.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:admin/screens/dashboard/components/node_apps_details.dart';

class PlotDashboard extends StatefulWidget {
  @override
  _PlotDashboardState createState() => _PlotDashboardState();
}

class _PlotDashboardState extends State<PlotDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: Text("Statistics"),
              backgroundColor: secondaryColor,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
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
                  ),
              ],
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      // MyCards(),
                      // SizedBox(height: defaultPadding),
                      RecentPlots(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) NodeAppsDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: BoxedPlots(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
