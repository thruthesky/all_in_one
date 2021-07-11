# 날씨


- OpenWeatherMap 을 통해서 날씨를 구현.
- 참고로 무료 버전은 쿼리 회수가 너무 작아 실 사용자가 하루 100명이 넘어 가면 쓰기 어렵다.
  - 월 40 달러 정도면, 월 1천만 쿼리 가능.
    - 1천만 쿼리를 30일로 나누고, 날씨 쿼리를 캐시하여 3분에 한번씩 쿼리 한다면, 사용자 당 평균 3회에서 10회 정도 (즉, 9분에서 30분 정도 앱을 본다면) 날짜 정보를 업데이트 한다면, 3천에서 1만명의 사용자를 커버 할 수 있다.

- 참고, OpenWeatherMap 에서 미세먼지 부분이 너무 맞지 않아, OpenWeatherMap 이 아닌 다른 국내 데이터를 사용해야 할 것 같다.



- 국내 참고 문서
  - https://www.me.go.kr/mamo/web/index.do?menuId=16201
  - https://www.jeonju.go.kr/index.9is?contentUid=9be517a765366314016578d7e2a3556e


- 국내 데이터 제공 참고 사이트
  - 주로 동네예보 조회 API 를 많이 사용하는데, 위도, 경도를 바탕으로 동네를 파악할 수 있는 DB 를 먼저 만들거나,
    - 참고: https://idlecomputer.tistory.com/320 를 보면, 위도/경도를 바탕으로 동네 예보 조회 하는 방법이 설명되어져 있다.
  - https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=ufo7142&logNo=220716957884
  - https://rubenchoi.tistory.com/48
  - https://blog.naver.com/whddn0330/222345858709
  - [기상청 격자 위치 정보와 위/경도 위치 정보 변환](https://fronteer.kr/service/kmaxy)


## UVI - 자외선 지수

- 참고 문서
http://www.climate.go.kr/home/09_monitoring/uv/uv_main
https://www.kma.go.kr/HELP/basic/help_01_06.jsp
https://100.daum.net/encyclopedia/view/39XXXXX00639


- 자외선 지수는 문서마다 지수 표기가 조금씩 다르다.
  - climate.go.kr 에 나오는 지수를 따른다.
  - 지수는 floor 처리한다.


## 미세먼지

- 미세먼지의 경우 Open Weather Map 의 것을 사용 할 수 없다. 정확도가 너무 떨어진다.
  - 국내 API 나 정보 제공 사이트를 찾아서 파싱을 해야 할 필요가 있다.

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

