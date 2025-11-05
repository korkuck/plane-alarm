import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../services/aero_api_service.dart';

part 'flight_destination_state.dart';

class FlightDestinationCubit extends Cubit<FlightDestinationState> {
  final AeroApiService api;
  FlightDestinationCubit(this.api) : super(FlightDestinationInitial());

  /// ident: flight designator or registration (prefer ICAO designator, e.g. "UAL4" or "BAW123")
  Future<void> fetchDestination(String ident, {String? identType}) async {
    try {
      emit(FlightDestinationLoading());
      final flights = await api.fetchFlightsByIdent(
        ident,
        identType: identType,
      );
      if (flights.isEmpty) {
        emit(FlightDestinationError('No flights found for $ident'));
        return;
      }

      // take first result (most recent/scheduled as API orders)
      final first = flights.first as Map<String, dynamic>;
      final destination = first['destination'] as Map<String, dynamic>?;
      if (destination == null) {
        emit(FlightDestinationError('Destination not available for $ident'));
        return;
      }

      // prefer readable name, fall back to IATA/ICAO codes
      final name = destination['name'] as String?;
      final iata = destination['code_iata'] as String?;
      final icao = destination['code_icao'] as String?;
      final display = name ?? iata ?? icao ?? 'unknown';

      // Print to VSCode console
      debugPrint('Flight $ident destination: $display');

      emit(FlightDestinationLoaded(display));
    } catch (e, st) {
      debugPrint('Error fetching destination: $e\n$st');
      emit(FlightDestinationError(e.toString()));
    }
  }
}
