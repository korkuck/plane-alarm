import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:plane_alarm/cubit/api_key_cubit.dart';
import 'package:plane_alarm/cubit/deep_link_cubit.dart';
import 'package:plane_alarm/cubit/flight_details_cubit.dart';
import 'package:plane_alarm/pages/input_api_key_page.dart';
import 'package:plane_alarm/services/notification_service.dart';
import 'package:plane_alarm/theme/my_theme_data.dart';
import 'package:plane_alarm/widgets/api_listener_widget.dart';
import 'package:timezone/data/latest_all.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterForegroundTask.initCommunicationPort();
  initializeTimeZones();
  await initializeNotifications();

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ApiKeyCubit()..lookForApiKey())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ApiKeyState apiKeyState = context.watch<ApiKeyCubit>().state;

    return MaterialApp(
      title: 'Plane Alarm',
      theme: MyThemeData.theme,
      home:
          apiKeyState is ApiKeyInitial
              ? const Center(child: CircularProgressIndicator())
              : apiKeyState is ApiKeyReady
              ? MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create:
                        (_) => FlightDetailsCubit(apiKeyState.aeroApiService),
                  ),
                  BlocProvider(create: (_) => DeepLinkCubit()),
                ],
                child: ApiListenerWidget(),
              )
              : const InputApiKeyPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
