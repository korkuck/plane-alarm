import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plane_alarm/cubit/arrival_plane_indicator_cubit.dart';
import 'package:plane_alarm/cubit/flight_destination_cubit.dart';
import 'package:plane_alarm/pages/home_page.dart';
import 'package:plane_alarm/services/aero_api_service.dart';
import 'package:plane_alarm/theme/my_theme_data.dart';

Future<void> main() async {
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
      providers: [
        BlocProvider(create: (_) => ArrivalPlaneIndicatorCubit()),
        BlocProvider(create: (_) => FlightDetailsCubit(api)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plane Alarm',
      theme: MyThemeData.theme,
      home: const MyHomePage(title: 'Plane Alarm'),
      debugShowCheckedModeBanner: false,
    );
  }
}
