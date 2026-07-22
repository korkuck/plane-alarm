class FlightDetails {
  String? callsign;
  String? destinationName;
  String? destinationIata;
  String? destinationIcao;
  String? destinationTimezone;
  String? originName;
  String? originIata;
  String? originIcao;
  String? originTimezone;
  double progressPercentRaw;
  String? scheduledOutRaw;
  String? scheduledInRaw;
  String? estimatedInRaw;
  String? actualOutRaw;
  int? arrivalDelayMinutes;
  bool? diverted;
  bool? emergency;
  DateTime? scheduledOutLocal;
  DateTime? actualOutLocal;
  DateTime? scheduledInLocal;
  DateTime? estimatedInLocal;

  FlightDetails({
    this.callsign,
    this.destinationName,
    this.destinationIata,
    this.destinationIcao,
    this.destinationTimezone,
    this.originName,
    this.originIata,
    this.originIcao,
    this.originTimezone,
    this.progressPercentRaw = 0.0,
    this.scheduledOutRaw,
    this.scheduledInRaw,
    this.estimatedInRaw,
    this.actualOutRaw,
    this.arrivalDelayMinutes,
    this.diverted,
    this.emergency,
    this.scheduledOutLocal,
    this.actualOutLocal,
    this.scheduledInLocal,
    this.estimatedInLocal,
  });

  FlightDetails copyWith({
    String? callsign,
    String? destinationName,
    String? destinationIata,
    String? destinationIcao,
    String? destinationTimezone,
    String? originName,
    String? originIata,
    String? originIcao,
    String? originTimezone,
    double? progressPercentRaw,
    String? scheduledOutRaw,
    String? scheduledInRaw,
    String? estimatedInRaw,
    String? actualOutRaw,
    int? arrivalDelayMinutes,
    bool? diverted,
    bool? emergency,
    DateTime? scheduledOutLocal,
    DateTime? actualOutLocal,
    DateTime? scheduledInLocal,
    DateTime? estimatedInLocal,
  }) {
    return FlightDetails(
      callsign: callsign ?? this.callsign,
      destinationName: destinationName ?? this.destinationName,
      destinationIata: destinationIata ?? this.destinationIata,
      destinationIcao: destinationIcao ?? this.destinationIcao,
      destinationTimezone: destinationTimezone ?? this.destinationTimezone,
      originName: originName ?? this.originName,
      originIata: originIata ?? this.originIata,
      originIcao: originIcao ?? this.originIcao,
      originTimezone: originTimezone ?? this.originTimezone,
      progressPercentRaw: progressPercentRaw ?? this.progressPercentRaw,
      scheduledOutRaw: scheduledOutRaw ?? this.scheduledOutRaw,
      scheduledInRaw: scheduledInRaw ?? this.scheduledInRaw,
      estimatedInRaw: estimatedInRaw ?? this.estimatedInRaw,
      actualOutRaw: actualOutRaw ?? this.actualOutRaw,
      arrivalDelayMinutes: arrivalDelayMinutes ?? this.arrivalDelayMinutes,
      diverted: diverted ?? this.diverted,
      emergency: emergency ?? this.emergency,
      scheduledOutLocal: scheduledOutLocal ?? this.scheduledOutLocal,
      actualOutLocal: actualOutLocal ?? this.actualOutLocal,
      scheduledInLocal: scheduledInLocal ?? this.scheduledInLocal,
      estimatedInLocal: estimatedInLocal ?? this.estimatedInLocal,
    );
  }

  FlightDetails jsonToFlightDetails(Map<String, dynamic> json) {
    return FlightDetails(
      callsign: json['callsign'] as String?,
      destinationName: json['destinationName'] as String?,
      destinationIata: json['destinationIata'] as String?,
      destinationIcao: json['destinationIcao'] as String?,
      destinationTimezone: json['destinationTimezone'] as String?,
      originName: json['originName'] as String?,
      originIata: json['originIata'] as String?,
      originIcao: json['originIcao'] as String?,
      originTimezone: json['originTimezone'] as String?,
      progressPercentRaw:
          (json['progressPercentRaw'] as num?)?.toDouble() ?? 0.0,
      scheduledOutRaw: json['scheduledOutRaw'] as String?,
      scheduledInRaw: json['scheduledInRaw'] as String?,
      estimatedInRaw: json['estimatedInRaw'] as String?,
      actualOutRaw: json['actualOutRaw'] as String?,
      arrivalDelayMinutes: json['arrivalDelayMinutes'] as int?,
      diverted: json['diverted'] as bool?,
      emergency: json['emergency'] as bool?,
      scheduledOutLocal: json['scheduledOutLocal'] as DateTime?,
      actualOutLocal: json['actualOutLocal'] as DateTime?,
      scheduledInLocal: json['scheduledInLocal'] as DateTime?,
      estimatedInLocal: json['estimatedInLocal'] as DateTime?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callsign': callsign,
      'destinationName': destinationName,
      'destinationIata': destinationIata,
      'destinationIcao': destinationIcao,
      'destinationTimezone': destinationTimezone,
      'originName': originName,
      'originIata': originIata,
      'originIcao': originIcao,
      'originTimezone': originTimezone,
      'progressPercentRaw': progressPercentRaw,
      'scheduledOutRaw': scheduledOutRaw,
      'scheduledInRaw': scheduledInRaw,
      'estimatedInRaw': estimatedInRaw,
      'actualOutRaw': actualOutRaw,
      'arrivalDelayMinutes': arrivalDelayMinutes,
      'diverted': diverted,
      'emergency': emergency,
      'scheduledOutLocal': scheduledOutLocal?.toIso8601String(),
      'actualOutLocal': actualOutLocal?.toIso8601String(),
      'scheduledInLocal': scheduledInLocal?.toIso8601String(),
      'estimatedInLocal': estimatedInLocal?.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonCallsign() {
    return {'callsign': callsign};
  }
}
