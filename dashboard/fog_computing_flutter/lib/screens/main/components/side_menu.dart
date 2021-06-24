import 'package:admin/controllers/MenuController.dart';
import 'package:admin/screens/main/components/actions.dart';
import 'package:admin/screens/main/components/applications.dart';
import 'package:admin/screens/main/plot_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:admin/screens/main/components/live_measurements.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(child: Text("Fog Computing Platform",style: TextStyle(color: Colors.white))),
            // child: Image.asset("assets/images/res.png"),
          ),

          DrawerListTile(
            title: " Live Measurement",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LiveMeasurements()));
            },
          ),
          DrawerListTile(
            title: "Statistics",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (context) => MenuController(),
                        ),
                      ],
                      child: PlotScreen(),
                    );}));
            },
          ),
          DrawerListTile(
            title: "Actions",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyActions()));
            },
          ),
          DrawerListTile(
            title: "Applications",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Applications()));
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
