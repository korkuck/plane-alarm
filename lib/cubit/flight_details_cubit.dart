import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../services/aero_api_service.dart';

part 'flight_destination_state.dart';

class FlightDetailsCubit extends Cubit<FlightDetailsState> {
  final AeroApiService api;
  FlightDetailsCubit(this.api) : super(FlightDetailsInitial());

  /// ident: flight designator or registration (prefer ICAO designator, e.g. "UAL4" or "BAW123")
  Future<void> fetchFlightData(String ident) async {
    try {
      emit(FlightDetailsLoading());
      final flights = await api.fetchFlightsByIdent(ident);
      if (flights.isEmpty) {
        return emit(FlightDetailsError('No flights found for $ident'));
      }

      // flighs moze zawierac wiele lotow (np divert), pierwszy aktualny
      final currentFlight = flights.first as Map<String, dynamic>;

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
        'destinationName': destination['name'],
        'destinationIata': destination['code_iata'],
        'destinationIcao': destination['code_icao'],
        'originName': origin['name'],
        'originIata': origin['code_iata'],
        'originIcao': origin['code_icao'],
        'progressPercentRaw': currentFlight['progress_percent'],
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
}
