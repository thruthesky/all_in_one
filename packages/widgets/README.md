# 위젯 패키지


## 중앙 정렬 위제

```dart
Column(
  children: [
    CenteredRow(left: Text('국가 이름(한글) : '), right: Text(country.koreanName)),
    CenteredRow(left: Text('국가 이름(영문) : '), right: Text(country.englishName)),
    CenteredRow(left: Text('국가 이름(공식) : '), right: Text(country.officialName)),
  ],
);
```

## 국가별 깃발(국기) 표시

```dart
flag('hk', width: 32),
```

