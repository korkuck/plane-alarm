import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'flight_details_cubit.dart';

class ArrivalPlaneIndicatorCubit extends Cubit<double> {
  final FlightDetailsCubit flightDetailsCubit;
  late final StreamSubscription flightSubscription;

  ArrivalPlaneIndicatorCubit(this.flightDetailsCubit) : super(0) {
    // Listen to FlightDetailsCubit state changes
    flightSubscription = flightDetailsCubit.stream.listen((state) {
      if (state is FlightDetailsLoaded) {
        final progressPercent =
            state.data['progressPercentRaw'].toString() as double?;
        if (progressPercent != null) {
          final angle = (progressPercent / 100) * 360;
          emit(angle);
        }
      }
      emit(0);
    });
  }

  @override
  Future<void> close() {
    flightSubscription.cancel(); // prevent memory leaks
    return super.close();
  }

  // Optional: rotate manually
  void rotateAirplane(double deltaDegrees) {
    emit((state + deltaDegrees) % 360);
  }
}
