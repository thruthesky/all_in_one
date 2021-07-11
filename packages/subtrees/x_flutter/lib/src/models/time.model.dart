class TimeModel {
  String time;

  TimeModel(this.time);

  @override
  String toString() => 'TimeModel(time: $time)';

  factory TimeModel.fromJson(Map<String, dynamic> json) {
    return TimeModel(json['time'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
    };
  }
}
