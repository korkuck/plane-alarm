import 'package:flutter_bloc/flutter_bloc.dart';

class ArrivalPlaneIndicatorCubit extends Cubit<double> {
  ArrivalPlaneIndicatorCubit() : super(0);

  void rotateAirplane(double deltaDegrees) {
    emit(state + deltaDegrees); //UNSAFE: DEGREES EXCEED 360
  }
}
