import 'dart:convert';
import 'package:http/http.dart' as http;

class AeroApiService {
  static const _base = 'https://aeroapi.flightaware.com/aeroapi';
  final String apiKey;

  AeroApiService(this.apiKey);

  /// Fetch flights by ident (registration, ICAO ident, or fa_flight_id)
  /// Returns the parsed JSON for the flights array (or throws).
  Future<List<dynamic>> fetchFlightsByIdent(String ident) async {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ); // midnight
    final yesterday = today.subtract(
      const Duration(days: 1),
    ); // midnight yesterday
    final todayIso = today.toIso8601String();
    final yesterdayIso = yesterday.toIso8601String();
    final uri = Uri.parse(
      '$_base/flights/$ident',
    ).replace(queryParameters: {'start': yesterdayIso, 'end': todayIso});
    final resp = await http.get(
      uri,
      headers: {'x-apikey': apiKey, 'Accept': 'application/json'},
    );

    if (resp.statusCode != 200) {
      throw Exception('AeroAPI error: ${resp.statusCode} ${resp.body}');
    }

    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    // The OpenAPI returns an object with "links", "num_pages", "flights" etc.
    return (json['flights'] as List<dynamic>? ?? []);
  }
}
