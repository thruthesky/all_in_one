class Temp {
	double? day;
	double? min;
	double? max;
	double? night;
	double? eve;
	double? morn;

	Temp({this.day, this.min, this.max, this.night, this.eve, this.morn});

	@override
	String toString() {
		return 'Temp(day: $day, min: $min, max: $max, night: $night, eve: $eve, morn: $morn)';
	}

	factory Temp.fromJson(Map<String, dynamic> json) => Temp(
				day: json['day'] as double?,
				min: json['min'] as double?,
				max: json['max'] as double?,
				night: json['night'] as double?,
				eve: json['eve'] as double?,
				morn: json['morn'] as double?,
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
