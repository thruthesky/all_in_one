import 'package:wordpress/wordpress.dart';

class WPPostVote {
  int id;
  int Y;
  int N;
  WPPostVote({
    required this.id,
    required this.Y,
    required this.N,
  });

  factory WPPostVote.fromJson(JSON json) {
    return WPPostVote(
      id: toInt(json['ID']),
      Y: toInt(json['Y']),
      N: toInt(json['N']),
    );
  }
}
