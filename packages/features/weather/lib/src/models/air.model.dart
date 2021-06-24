class AirModel {
  Map<String, dynamic> data;
  AirModel(Map<String, dynamic> json) : data = json;
  factory AirModel.fromJson(Map<String, dynamic> json) => AirModel(json);

  Map<String, String> get finDust {
    final num? dust = data['list']?[0]?['components']?['pm2_5'];
    if (dust == null) return {'text': '모름'};
    if (dust < 16)
      return {'text': '좋음', 'icon': 'face/smiling'};
    else if (dust < 36)
      return {'text': '보통', 'icon': 'face/fair'};
    else if (dust < 76)
      return {'text': '나쁨', 'icon': 'face/angry'};
    else
      return {'text': '매우 나쁨', 'icon': 'face/devil'};
  }

  Map<String, String> get coarseDust {
    final num? dust = data['list']?[0]?['components']?['pm10'];
    print('coarse: $dust');
    if (dust == null) return {'text': '모름'};
    if (dust < 31)
      return {'text': '좋음', 'icon': 'face/smiling'};
    else if (dust < 81)
      return {'text': '보통', 'icon': 'face/fair'};
    else if (dust < 151)
      return {'text': '나쁨', 'icon': 'face/angry'};
    else
      return {'text': '매우 나쁨', 'icon': 'face/devil'};
  }
}
