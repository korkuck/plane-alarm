import 'package:flutter/material.dart';
import 'package:plane_alarm/widgets/arrival_info_widget.dart';
import 'package:plane_alarm/widgets/flight_info_column.dart';
import 'package:plane_alarm/widgets/my_bottom_app_bar.dart';
import 'package:plane_alarm/widgets/my_top_app_bar.dart';
import 'package:plane_alarm/widgets/plane_over_earth_widget.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyTopAppBar(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(36, 16, 36, 0),
            child: FlightInfoColumn(),
          ),
          const PlaneOverEarthWidget(),
          const ArrivalInfoWidget(),
        ],
      ),
      bottomNavigationBar: MyBottomAppBar(),
    );
  }
}
