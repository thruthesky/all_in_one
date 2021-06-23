class Minutely {
	int? dt;
	int? precipitation;

	Minutely({this.dt, this.precipitation});

	@override
	String toString() => 'Minutely(dt: $dt, precipitation: $precipitation)';

	factory Minutely.fromJson(Map<String, dynamic> json) => Minutely(
				dt: json['dt'] as int?,
				precipitation: json['precipitation'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'dt': dt,
				'precipitation': precipitation,
			};
}
