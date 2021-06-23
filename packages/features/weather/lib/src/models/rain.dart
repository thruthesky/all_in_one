class Rain {
  double? h;

  Rain({this.h});

  @override
  String toString() => 'Rain(1h: $h)';

  factory Rain.fromJson(Map<String, dynamic> json) => Rain(
        h: json['1h'] as double?,
      );

  Map<String, dynamic> toJson() => {
        '1h': h,
      };
}
