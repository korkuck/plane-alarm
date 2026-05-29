import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plane_alarm/cubit/flight_details_cubit.dart';
import 'package:plane_alarm/pages/home_page.dart';
import 'package:plane_alarm/services/aero_api_service.dart';
import 'package:plane_alarm/services/notification_service.dart';
import 'package:plane_alarm/theme/my_theme_data.dart';
import 'package:plane_alarm/variables/global_variables.dart';
import 'package:timezone/data/latest_all.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();
  await initializeNotifications();
  // Load .env file
  await dotenv.load(fileName: ".env");

  final apiKey = dotenv.env['AEROAPI_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    debugPrint('AEROAPI_KEY missing in .env — aborting startup.');
    return;
  }

  final api = AeroApiService(apiKey);

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => FlightDetailsCubit(api))],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FlightDetailsCubit>().initialize(
      kDebugMode == true ? globalInitialCallsign : "",
    );
    Timer.periodic(const Duration(minutes: globalRefreshDelayMinutes), (_) {
      context.read<FlightDetailsCubit>().refreshCubit();
    });

    return BlocListener<FlightDetailsCubit, FlightDetailsState>(
      listener: (context, state) {
        if (state is FlightDetailsLoaded) {
          final progress = (state.flightDetails.progressPercentRaw).round();
          showProgressStatusBarNotification(progress);
        }
      },
      child: MaterialApp(
        title: 'Plane Alarm',
        theme: MyThemeData.theme,
        home: const MyHomePage(title: 'Plane Alarm'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
