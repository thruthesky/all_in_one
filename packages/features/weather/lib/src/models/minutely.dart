class Minutely {
	num? dt;
	num? precipitation;

	Minutely({this.dt, this.precipitation});

	@override
	String toString() => 'Minutely(dt: $dt, precipitation: $precipitation)';

	factory Minutely.fromJson(Map<String, dynamic> json) => Minutely(
				dt: json['dt'] as num?,
				precipitation: json['precipitation'] as num?,
			);

	Map<String, dynamic> toJson() => {
				'dt': dt,
				'precipitation': precipitation,
			};
}
