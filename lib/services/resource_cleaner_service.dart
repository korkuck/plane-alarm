import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plane_alarm/cubit/flight_details_cubit.dart';
import 'package:plane_alarm/services/flight_foreground_service.dart';
import 'package:plane_alarm/services/notification_service.dart';
import 'package:plane_alarm/widgets/my_text.dart';

Future<void> clearTemporaryDirectory() async {
  try {
    final dir = await getTemporaryDirectory();

    if (await dir.exists()) {
      await for (final entity in dir.list()) {
        await entity.delete(recursive: true);
      }
    }
  } catch (e) {
    debugPrint("⚠ Could not clear temporary directory: $e");
  }
}

Future<void> clearCache() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync().whereType<File>();
    for (final file in files) {
      if (file.path.contains('flights_local_backup_')) {
        await file.delete();
        debugPrint("🗑 Deleted cache file: ${file.path}");
      }
    }
  } catch (e) {
    debugPrint("⚠ Could not clear cache: $e");
  }
}

Future<void> stopCallsignTracking(BuildContext context) async {
  final flightForegroundService = const FlightForegroundService();
  final flightDetailsCubit = context.read<FlightDetailsCubit>();
  await flightForegroundService.stop();
  flightDetailsCubit.stopRefreshing();
  await cancelAllAppNotifications();
  clearTemporaryDirectory();
  //TODO: Fix context in async issue
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: MySmallText(
        'Background tracking stopped and cache cleared',
        color: Colors.white,
      ),
      backgroundColor: Colors.red,
    ),
  );
}
