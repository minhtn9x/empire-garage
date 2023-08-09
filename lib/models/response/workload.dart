class Workload {
  int totalPoints;
  DateTime intendedFinishTime;
  int minutesPerWorkload;

  Workload({
    required this.totalPoints,
    required this.intendedFinishTime,
    required this.minutesPerWorkload,
  });

  factory Workload.fromJson(Map<String, dynamic> json) {
    return Workload(
        totalPoints: json['totalPoints'],
        intendedFinishTime: DateTime.parse(json['intendedFinishTime']),
        minutesPerWorkload: json['minutesPerWorkload']);
  }
}
