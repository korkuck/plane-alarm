part of 'deep_link_cubit.dart';

abstract class DeepLinkState extends Equatable {
  const DeepLinkState();

  @override
  List<Object?> get props => [];
}

final class DeepLinkInitial extends DeepLinkState {
  const DeepLinkInitial();
}

final class DeepLinkCallsignReceived extends DeepLinkState {
  const DeepLinkCallsignReceived(this.callsign);

  final String callsign;

  @override
  List<Object?> get props => [callsign];
}
