import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plane_alarm/cubit/flight_destination_cubit.dart';
import 'package:plane_alarm/pages/home_page.dart';
import 'package:plane_alarm/services/aero_api_service.dart';
import 'package:plane_alarm/theme/my_theme_data.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e, st) {
    debugPrint('dotenv load failed: $e\n$st');
  }

  final apiKey = dotenv.env['AEROAPI_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    debugPrint('AEROAPI_KEY missing in .env — aborting startup.');
    return;
  }

  final api = AeroApiService(apiKey);
  final cubit = FlightDestinationCubit(api);

  // Example: fetch and print destination for an ICAO-style ident
  await cubit.fetchDestination('WZZ56RD'); // or 'UAL4', or 'SWA35' etc.

  // If you want to react to states:
  cubit.stream.listen((state) {
    if (state is FlightDestinationLoaded) {
      // do something in the app
      debugPrint('Loaded dest: ${state.destination}');
    } else if (state is FlightDestinationError) {
      debugPrint('Error: ${state.message}');
    }
  });

  runApp(const MyApp());
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
