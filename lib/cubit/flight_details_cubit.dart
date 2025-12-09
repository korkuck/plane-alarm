import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../services/aero_api_service.dart';

part 'flight_details_state.dart';

class FlightDetailsCubit extends Cubit<FlightDetailsState> {
  final AeroApiService api;
  String targetCallsign = "";
  FlightDetailsCubit(this.api) : super(FlightDetailsInitial());

  void initialize(String initialCallsign) {
    fetchFlightData(targetCallsign = initialCallsign);
    if (targetCallsign.isEmpty) {
      emit(FlightDetailsError('No callsign provided'));
    }
  }

  void refreshCubit() {
    fetchFlightData(targetCallsign);
  }

  void setTargetCallsign(String callsign) {
    targetCallsign = callsign;
    fetchFlightData(targetCallsign);
  }

  void getTargetCallsign() {
    emit(FlightDetailsInitial());
  }

  /// ident: flight designator or registration (prefer ICAO designator, e.g. "UAL4" or "BAW123")
  Future<void> fetchFlightData(String ident) async {
    try {
      emit(FlightDetailsLoading());
      final flights = await api.fetchFlightsByIdent(ident);
      if (flights.isEmpty) {
        return emit(FlightDetailsError('No flights found for $ident'));
      }

      // flighs moze zawierac wiele lotow (np divert), pierwszy aktualny
      final currentFlight = _findOngoingFlight(flights);
      if (currentFlight == null) {
        return emit(FlightDetailsError('No ongoing flight found for $ident'));
      }

      final destination = currentFlight['destination'] as Map<String, dynamic>?;
      if (destination == null) {
        return emit(FlightDetailsError('Destination not available for $ident'));
      }

      final origin = currentFlight['origin'] as Map<String, dynamic>?;
      if (origin == null) {
        emit(FlightDetailsError('Origin not available for $ident'));
        return;
      }

      final fetchResult = {
        'callsign': ident,
        'destinationName': destination['name'],
        'destinationIata': destination['code_iata'],
        'destinationIcao': destination['code_icao'],
        'originName': origin['name'],
        'originIata': origin['code_iata'],
        'originIcao': origin['code_icao'],
        'progressPercentRaw':
            (currentFlight['progress_percent'] as num?)?.toDouble() ?? 0.0,
        'scheduledOutRaw': currentFlight['scheduled_out'],
        'scheduledInRaw': currentFlight['scheduled_in'],
      };

      // Print to VSCode console
      debugPrint(
        'Flight $ident destination: ${fetchResult['destinationName']} | origin: ${fetchResult['originName']}',
      );

      emit(FlightDetailsLoaded(fetchResult));
    } catch (e, st) {
      debugPrint('Error fetching flight info: $e\n$st');
      emit(FlightDetailsError(e.toString()));
    }
  }

  _findOngoingFlight(List<dynamic> flights) {
    final now = DateTime.now().toUtc();

    for (final f in flights) {
      final flight = f as Map<String, dynamic>;

      //TODO: some flights are en-route but have missing data, handle that properly
      //TODO: handle future flights!
      if (flight['status'].toString().toLowerCase() == 'en route') {
        return flight;
      }

      if (flight['progress_percent'] == null) {
        continue;
      }

      final progress = (flight['progress_percent'] as num?)?.toDouble();

      // Case 1 – Actively flying (most accurate indicator)
      if (progress != null && progress > 0 && progress < 100) return flight;

      // Case 2 – Departed but not arrived yet, only for position-only flights
      if (flight['actual_out'] != null && flight['actual_in'] == null) {
        return flight;
      }

      // Case 3 – Fallback by scheduled time window
      final out = DateTime.tryParse(flight['scheduled_out'] ?? '')?.toUtc();
      final in_ = DateTime.tryParse(flight['estimated_in'] ?? '')?.toUtc();
      if (out != null && in_ != null && now.isAfter(out) && now.isBefore(in_)) {
        return flight;
      }
    }

    return null; // no active flight found
  }
}
