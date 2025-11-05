import 'package:flutter_bloc/flutter_bloc.dart';

class ArrivalCubit extends Cubit<double> {
  ArrivalCubit() : super(0);

  void rotateAirplane(double deltaDegrees) {
    emit(state + deltaDegrees); //UNSAFE: DEGREES EXCEED 360
  }
}
