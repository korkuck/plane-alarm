import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:plane_alarm/classes/flight_details.dart';
import 'package:plane_alarm/services/notification_service.dart';
import 'package:timezone/timezone.dart';
import '../services/aero_api_service.dart';

part 'flight_details_state.dart';

class FlightDetailsCubit extends Cubit<FlightDetailsState> {
  final AeroApiService api;
  String targetCallsign = "";
  FlightDetailsCubit(this.api) : super(FlightDetailsInitial());

  void initialize(String initialCallsign) {
    // Debug callsign for testing
    targetCallsign = initialCallsign;
    if (targetCallsign.isEmpty) {
      emit(FlightDetailsError('No callsign provided'));
    } else {
      fetchFlightData(targetCallsign, firstDownload: true);
    }
  }

  void refreshCubit() {
    fetchFlightData(targetCallsign);
  }

  void setTargetCallsign(String callsign) {
    targetCallsign = callsign;
    fetchFlightData(targetCallsign, firstDownload: true);
  }

  void getTargetCallsign() {
    emit(FlightDetailsInitial());
  }

  void manualDelay(int minutes) {
    if (state is FlightDetailsLoaded) {
      final currentFlightDetails = (state as FlightDetailsLoaded).flightDetails;
      emit(FlightDetailsLoading());
      final updatedFlightDetails = currentFlightDetails.copyWith(
        arrivalDelayMinutes:
            (currentFlightDetails.arrivalDelayMinutes ?? 0) + minutes,
      );
      pushNotification('Flight was delayed by $minutes minutes');
      emit(FlightDetailsLoaded(updatedFlightDetails));
    }
  }

  void manualChangeDestination(String newIata, String newName) {
    if (state is FlightDetailsLoaded) {
      final currentFlightDetails = (state as FlightDetailsLoaded).flightDetails;
      emit(FlightDetailsLoading());
      final updatedFlightDetails = currentFlightDetails.copyWith(
        destinationIata: newIata,
        destinationName: newName,
        diverted: true,
      );
      pushNotification('URGENT: Flight was diverted to $newName ($newIata)');
      emit(FlightDetailsLoaded(updatedFlightDetails));
    }
  }

  double getProgressPercent() {
    if (state is FlightDetailsLoaded) {
      final flightDetails = (state as FlightDetailsLoaded).flightDetails;
      return flightDetails.progressPercentRaw;
    }
    return 0;
  }

  /// ident: flight designator or registration (prefer ICAO designator, e.g. "UAL4" or "BAW123")
  Future<void> fetchFlightData(
    String ident, {
    bool firstDownload = false,
  }) async {
    try {
      emit(FlightDetailsLoading());
      final flights = await api.fetchFlightsByIdent(
        ident,
        firstDownload: firstDownload,
      );
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
      final arrivalDelaySeconds = currentFlight['arrival_delay'] as int? ?? 0;
      final arrivalDelayMinutes = arrivalDelaySeconds ~/ 60;

      final fetchResultJson = {
        'callsign': ident as String?,
        'destinationName': destination['name'] as String?,
        'destinationIata': destination['code_iata'] as String?,
        'destinationIcao': destination['code_icao'] as String?,
        'destinationTimezone': destination['timezone'] as String?,
        'originName': origin['name'] as String?,
        'originIata': origin['code_iata'] as String?,
        'originIcao': origin['code_icao'] as String?,
        'originTimezone': origin['timezone'] as String?,
        'progressPercentRaw':
            (currentFlight['progress_percent'] as int?)?.toDouble() ?? 0.0,
        'scheduledOutRaw': currentFlight['scheduled_out'] as String?,
        'scheduledInRaw': currentFlight['scheduled_in'] as String?,
        'estimatedInRaw': currentFlight['estimated_in'] as String?,
        'actualOutRaw': currentFlight['actual_out'] as String?,
        'arrivalDelayMinutes':
            arrivalDelayMinutes > 0 ? arrivalDelayMinutes : 0,
        'diverted': currentFlight['diverted'] as bool? ?? false,
        'emergency': false,
        'scheduledOutLocal': _fromUTCtoLocal(
          currentFlight['scheduled_out'],
          origin['timezone'],
        ),
        'actualOutLocal': _fromUTCtoLocal(
          currentFlight['actual_out'],
          origin['timezone'],
        ),
        'scheduledInLocal': _fromUTCtoLocal(
          currentFlight['scheduled_in'],
          destination['timezone'],
        ),
        'estimatedInLocal': _fromUTCtoLocal(
          currentFlight['estimated_in'],
          destination['timezone'],
        ),
      };

      final flightDetails = FlightDetails().jsonToFlightDetails(
        fetchResultJson,
      );
      emit(FlightDetailsLoaded(flightDetails));
    } catch (e, st) {
      debugPrint('Error fetching flight info: $e\n$st');
      emit(FlightDetailsError(e.toString()));
    }
  }

  DateTime? _fromUTCtoLocal(String? utcDateRaw, String? timezone) {
    final utcDate = DateTime.tryParse(utcDateRaw ?? '');
    if (utcDate == null) return null;
    if (timezone == null) return utcDate;
    try {
      final location = getLocation(timezone);
      return TZDateTime.from(utcDate, location);
    } catch (e) {
      debugPrint('Error converting time: $e');
      return utcDate;
    }
  }

  _findOngoingFlight(List<dynamic> flights) {
    final now = DateTime.now().toUtc();

    for (final f in flights) {
      final flight = f as Map<String, dynamic>;

      //TODO: some flights are en-route but have missing data, handle that properly
      //TODO: handle future flights!
      if (flight['status'].toString().toLowerCase().contains('en route')) {
        return flight;
      }

      if (flight['progress_percent'] == null) {
        continue;
      }

      final progress = (flight['progress_percent'] as num?)?.toDouble();

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
