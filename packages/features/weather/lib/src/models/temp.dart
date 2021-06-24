class Temp {
	num? day;
	num? min;
	num? max;
	num? night;
	num? eve;
	num? morn;

	Temp({this.day, this.min, this.max, this.night, this.eve, this.morn});

	@override
	String toString() {
		return 'Temp(day: $day, min: $min, max: $max, night: $night, eve: $eve, morn: $morn)';
	}

	factory Temp.fromJson(Map<String, dynamic> json) => Temp(
				day: json['day'] as num?,
				min: json['min'] as num?,
				max: json['max'] as num?,
				night: json['night'] as num?,
				eve: json['eve'] as num?,
				morn: json['morn'] as num?,
			);

	Map<String, dynamic> toJson() => {
				'day': day,
				'min': min,
				'max': max,
				'night': night,
				'eve': eve,
				'morn': morn,
			};
}
