import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'deep_link_state.dart';

class DeepLinkCubit extends Cubit<DeepLinkState> {
  DeepLinkCubit() : super(const DeepLinkInitial());

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  Future<void> startListening() async {
    final initialUri = await _appLinks.getInitialLink();

    if (initialUri != null) {
      _handleUri(initialUri);
    }

    _subscription = _appLinks.uriLinkStream.listen(_handleUri);
  }

  void _handleUri(Uri uri) {
    final segments = uri.pathSegments;
    final flightIndex = segments.indexOf('flight');

    if (flightIndex == -1 || segments.length <= flightIndex + 1) {
      return;
    }

    final callsign =
        segments[flightIndex + 1]
            .trim()
            .toUpperCase(); //TODO: In case of future link format changes, beware this trim

    if (callsign.isEmpty) {
      return;
    }

    emit(DeepLinkCallsignReceived(callsign));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
