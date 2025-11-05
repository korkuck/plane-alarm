import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plane_alarm/cubit/arrival_cubit.dart';
import 'package:plane_alarm/widgets/arrival_info_widget.dart';
import 'package:plane_alarm/widgets/flight_info_column.dart';
import 'package:plane_alarm/widgets/my_bottom_app_bar.dart';
import 'package:plane_alarm/widgets/plane_over_earth_widget.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArrivalCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plane Alarm'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(48, 40, 48, 0),
              child: FlightInfoColumn(),
            ),
            const SizedBox(height: 60),
            const PlaneOverEarthWidget(),
            const SizedBox(height: 60),
            const ArrivalInfoWidget(),
          ],
        ),
        bottomNavigationBar: MyBottomAppBar(),
      ),
    );
  }
}
