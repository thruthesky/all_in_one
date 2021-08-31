class TourApiAreaCodeModel {
  const TourApiAreaCodeModel({
    required this.code,
    required this.name,
    required this.rnum,
  });

  final int code;
  final String name;
  final int rnum;

  factory TourApiAreaCodeModel.fromJson(Map<String, dynamic> json) => TourApiAreaCodeModel(
        code: json["code"],
        name: json["name"],
        rnum: json["rnum"],
      );
}
