import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:plane_alarm/variables/global_variables.dart';

class AeroApiService {
  static const _base = 'https://aeroapi.flightaware.com/aeroapi';
  final String apiKey;

  AeroApiService(this.apiKey);

  /// Fetch flights by ident (registration, ICAO ident, or fa_flight_id)
  /// Returns the parsed JSON for the flights array (or throws).
  Future<List<dynamic>> fetchFlightsByIdent(
    String ident, {
    bool firstDownload = false,
  }) async {
    if (firstDownload) clearCache();
    if (kDebugMode || globalUseOfflineData) {
      debugPrint('Checking flight backups for ident: $ident');
      final backupFile = await _loadBackup(ident);
      if (backupFile != null && backupFile.isNotEmpty) {
        debugPrint('Loaded backup data for $ident');
        return backupFile;
      }
      debugPrint('No backup data found for $ident, fetching from AeroAPI.');
    }

    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ); // midnight
    final yesterday = today.subtract(
      const Duration(days: 1),
    ); // midnight yesterday
    final tomorrow = today.add(const Duration(days: 1)); // midnight tomorrow
    final tomorrowIso = tomorrow.toIso8601String();
    final yesterdayIso = yesterday.toIso8601String();
    final uri = Uri.parse(
      '$_base/flights/$ident',
    ).replace(queryParameters: {'start': yesterdayIso, 'end': tomorrowIso});
    final resp = await http.get(
      uri,
      headers: {'x-apikey': apiKey, 'Accept': 'application/json'},
    );

    if (resp.statusCode != 200) {
      throw Exception('AeroAPI error: ${resp.statusCode} ${resp.body}');
    }

    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    final flights = json['flights'] as List<dynamic>? ?? [];

    if (kDebugMode || globalUseOfflineData) await _saveBackup(ident, flights);

    return flights;
  }

  Future<File> _backupFile(String ident) async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/flights_local_backup_$ident.json");
  }

  Future<List<dynamic>?> _loadBackup(String ident) async {
    try {
      final file = await _backupFile(ident);
      if (!await file.exists()) return null;

      final content = await file.readAsString();
      if (content.isEmpty) return null;

      final json = jsonDecode(content) as Map<String, dynamic>;
      return json['flights'] as List<dynamic>?;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveBackup(String ident, List<dynamic> flights) async {
    try {
      final file = await _backupFile(ident);
      final wrappedData = {
        'timestamp': DateTime.now().toIso8601String(),
        'ident': ident,
        'flights': flights,
      };
      if (await file.exists()) {
        await file.delete();
        await file.create();
      }
      await file.writeAsString(jsonEncode(wrappedData), flush: true);
      debugPrint("✅ Backup saved for $ident, at location ${file.path}");
    } catch (e) {
      debugPrint("⚠ Could not save backup for $ident: $e");
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

  //TODO: CLEAR CACHED DATA ON NEW CALLSIGN SEARCHED.
}
