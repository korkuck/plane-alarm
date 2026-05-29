part of 'flight_details_cubit.dart';

abstract class FlightDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FlightDetailsInitial extends FlightDetailsState {}

class FlightDetailsLoading extends FlightDetailsState {}

class FlightDetailsLoaded extends FlightDetailsState {
  final FlightDetails flightDetails;
  FlightDetailsLoaded(this.flightDetails);
  @override
  List<Object?> get props => [flightDetails];
}

class FlightDetailsError extends FlightDetailsState {
  final String message;
  FlightDetailsError(this.message);
  @override
  List<Object?> get props => [message];
}
