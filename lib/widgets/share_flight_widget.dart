import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plane_alarm/cubit/flight_details_cubit.dart';
import 'package:plane_alarm/widgets/my_text.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareFlightWidget extends StatelessWidget {
  final FlightDetailsCubit flightDetailsCubit;

  const ShareFlightWidget({super.key, required this.flightDetailsCubit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const MyBoldText('Share Flight Info'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OverflowBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => shareFlightInfoJSON(),
                icon: const Icon(Icons.file_present_outlined),
                label: const Text('Save flight as JSON'),
              ),
              TextButton.icon(
                onPressed: () => shareFlightRadarURI(context),
                icon: const Icon(Icons.link),
                label: const Text('Share FR24 URI link'),
              ),
              TextButton.icon(
                onPressed: () => shareFlightQR(context, flightDetailsCubit),
                icon: const Icon(Icons.qr_code),
                label: const Text('Show QR code'),
              ),
              TextButton.icon(
                onPressed: () => shareAppWithCurrentFlight(flightDetailsCubit),
                icon: const Icon(Icons.airplanemode_active),
                label: const Text('Share app with current flight'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void shareFlightQR(BuildContext context, FlightDetailsCubit cubit) {
    final String callsign = cubit.getCurrentCallsign();

    if (callsign.isEmpty) {
      debugPrint("Fill in callsign before sharing the app");
      return;
    }

    final String appLink =
        'https://korkuck.github.io/plane-alarm/flight/$callsign';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "QR",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: _QrCard(address: appLink),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        final scale = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);

        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
    );
  }

  Future<void> shareFlightRadarURI(BuildContext context) async {
    final flightDetails =
        flightDetailsCubit.state is FlightDetailsLoaded
            ? (flightDetailsCubit.state as FlightDetailsLoaded).flightDetails
            : null;
    final flightCallsign = flightDetails?.callsign ?? '';
    final uri = Uri.parse('https://flightradar24.com/$flightCallsign');

    final params = ShareParams(uri: uri);

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      debugPrint("URI FR24 shared successfully");
    } else {
      debugPrint("Failed to share URI FR24: ${result.status}");
    }
  }

  Future<void> shareFlightInfoJSON() async {
    final flightDetails =
        flightDetailsCubit.state is FlightDetailsLoaded
            ? (flightDetailsCubit.state as FlightDetailsLoaded).flightDetails
            : null;
    final flightDetailsJson = flightDetails?.toJson() ?? {};
    final phoneDir = await getApplicationDocumentsDirectory();
    final jsonFile = File('${phoneDir.path}/flight_details_to_share.json');
    await jsonFile.writeAsString(jsonEncode(flightDetailsJson));
    final params = ShareParams(files: [XFile(jsonFile.path)]);
    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      debugPrint("JSON file shared successfully");
    } else {
      debugPrint("Failed to share JSON file: ${result.status}");
    }
  }

  Future<void> shareAppWithCurrentFlight(FlightDetailsCubit cubit) async {
    final String callsign = cubit.getCurrentCallsign();

    if (callsign.isEmpty) {
      debugPrint("Fill in callsign before sharing the app");
      return;
    }

    final appLink = Uri.parse(
      'https://korkuck.github.io/plane-alarm/flight/$callsign',
    );

    final params = ShareParams(uri: appLink);

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      debugPrint("App link shared successfully");
    } else {
      debugPrint("Failed to share app link: ${result.status}");
    }
  }
}

class _QrCard extends StatelessWidget {
  final String address;

  const _QrCard({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: QrImageView(
        data: address,
        version: QrVersions.auto,
        size: 280,
        backgroundColor: Colors.white,
      ),
    );
  }
}
