class ClientInitResponse {
  final XhuStartTime xhuStartTime;

  ClientInitResponse({required this.xhuStartTime});

  factory ClientInitResponse.fromJson(Map<String, dynamic> json) {
    return ClientInitResponse(
      xhuStartTime: XhuStartTime.fromJson(json['xhuStartTime']),
    );
  }
}

class XhuStartTime {
  final DateTime startDate;
  final int nowYear;
  final int nowTerm;

  XhuStartTime(
      {required this.startDate, required this.nowYear, required this.nowTerm});

  factory XhuStartTime.fromJson(Map<String, dynamic> json) {
    return XhuStartTime(
      startDate: DateTime.parse(json['startDate']),
      nowYear: json['nowYear'],
      nowTerm: json['nowTerm'],
    );
  }
}
