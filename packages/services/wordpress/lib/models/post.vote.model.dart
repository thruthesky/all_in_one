import '../defines.dart';

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
      id: json['ID'],
      Y: json['Y'],
      N: json['N'],
    );
  }
}
