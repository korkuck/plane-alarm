part of 'api_key_cubit.dart';

abstract class ApiKeyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApiKeyInitial extends ApiKeyState {}

class ApiKeyMissing extends ApiKeyState {
  final String message;
  ApiKeyMissing(this.message);
  @override
  List<Object?> get props => [message];
}

class ApiKeyReady extends ApiKeyState {
  ApiKeyReady({required this.apiKey, required this.aeroApiService});

  final String apiKey;
  final AeroApiService aeroApiService;

  @override
  List<Object?> get props => [apiKey, aeroApiService];
}

class ApiKeyError extends ApiKeyState {
  final String message;
  ApiKeyError(this.message);
  @override
  List<Object?> get props => [message];
}
