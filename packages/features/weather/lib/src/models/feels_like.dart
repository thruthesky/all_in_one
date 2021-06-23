class FeelsLike {
	num? day;
	num? night;
	num? eve;
	num? morn;

	FeelsLike({this.day, this.night, this.eve, this.morn});

	@override
	String toString() {
		return 'FeelsLike(day: $day, night: $night, eve: $eve, morn: $morn)';
	}

	factory FeelsLike.fromJson(Map<String, dynamic> json) => FeelsLike(
				day: json['day'] as num?,
				night: json['night'] as num?,
				eve: json['eve'] as num?,
				morn: json['morn'] as num?,
			);

	Map<String, dynamic> toJson() => {
				'day': day,
				'night': night,
				'eve': eve,
				'morn': morn,
			};
}
