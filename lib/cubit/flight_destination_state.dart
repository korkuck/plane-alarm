part of 'flight_destination_cubit.dart';

abstract class FlightDestinationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FlightDestinationInitial extends FlightDestinationState {}

class FlightDestinationLoading extends FlightDestinationState {}

class FlightDestinationLoaded extends FlightDestinationState {
  final String destination;
  FlightDestinationLoaded(this.destination);
  @override
  List<Object?> get props => [destination];
}

class FlightDestinationError extends FlightDestinationState {
  final String message;
  FlightDestinationError(this.message);
  @override
  List<Object?> get props => [message];
}
