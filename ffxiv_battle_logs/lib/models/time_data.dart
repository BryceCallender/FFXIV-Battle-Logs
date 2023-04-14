class TimeData {
  final int startTime;
  final int endTime;

  Duration get duration {
    return Duration(milliseconds: endTime - startTime);
  }

  TimeData.fromJson(Map<String, dynamic> json)
      : startTime = json['startTime'],
        endTime = json['endTime'];
}