# 날씨


- OpenWeatherMap 을 통해서 날씨를 구현.
- 참고로 무료 버전은 쿼리 회수가 너무 작아 실 사용자가 하루 100명이 넘어 가면 쓰기 어렵다.
  - 월 40 달러 정도면, 월 1천만 쿼리 가능.
    - 1천만 쿼리를 30일로 나누고, 날씨 쿼리를 캐시하여 3분에 한번씩 쿼리 한다면, 사용자 당 평균 3회에서 10회 정도 (즉, 9분에서 30분 정도 앱을 본다면) 날짜 정보를 업데이트 한다면, 3천에서 1만명의 사용자를 커버 할 수 있다.


## UVI - 자외선 지수

- 참고 문서
http://www.climate.go.kr/home/09_monitoring/uv/uv_main
https://www.kma.go.kr/HELP/basic/help_01_06.jsp
https://100.daum.net/encyclopedia/view/39XXXXX00639


- 자외선 지수는 문서마다 지수 표기가 조금씩 다르다.
  - climate.go.kr 에 나오는 지수를 따른다.
  - 지수는 floor 처리한다.




## 날씨 기능 코드 설명

### 초기화

- 날씨 기능을 쓰기 위해서는 초기화를 해야 한다.
- 초기화 할 때, 새로운 데이터를 가져 올 (업데이트) 주기를 설정 할 수 있으며, 그 업데이트 주기 마다 OpenWeatherMap 으로 부터 데이터를 가져와서 업데이트를 한다.
업데이트가 후 `dataChanges` 이벤트가 발생시키는데, 이벤트를 listen() 하면 꼭 cancel() 해주도록 한다.


  - 예제) 초기화
```dart
WeatherService.instance.init(
  apiKey: Config.openWeatherMapApiKey, // Api key
  updateInterval: Config.openWeatherMapUpdateInterval, // 업데이트 주기
);
```


- 초기화를 한 다음, 날씨 정보를 수신 할 수 있다. `dataChanges` 이벤트를 listen 하면, 날씨 정보가 업데이트 될 때 마다 원하는 작업을 할 수 있다.

  - 예제) 업데이트가 발생한 경우 핸들링
```dart
WeatherService.instance.dataChanges.listen((data) {
  final String? icon = (data as WeatherModel).current?.weather?[0].icon;
    if (icon != null) {
      print("https://openweathermap.org/img/wn/$icon@2x.png");
    }
});
```

- 참고로 날씨 정보는 내부적으로 업데이트 주기 마다 새로운 데이터를 서버로 부터 가져오지만, 원하는 경우 프로그램적으로 업데이트 하게 할 수 있다.

  - 예제) 날씨 데이터 업데이트하기
```dart
WeatherService.instance.updateWeather().then((value) => print(value));
```

