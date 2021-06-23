class FeelsLike {
	double? day;
	double? night;
	double? eve;
	double? morn;

	FeelsLike({this.day, this.night, this.eve, this.morn});

	@override
	String toString() {
		return 'FeelsLike(day: $day, night: $night, eve: $eve, morn: $morn)';
	}

	factory FeelsLike.fromJson(Map<String, dynamic> json) => FeelsLike(
				day: json['day'] as double?,
				night: json['night'] as double?,
				eve: json['eve'] as double?,
				morn: json['morn'] as double?,
			);

	Map<String, dynamic> toJson() => {
				'day': day,
				'night': night,
				'eve': eve,
				'morn': morn,
			};
}
