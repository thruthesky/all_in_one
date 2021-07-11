카카오 지도
===============
 
## #kakaomap_webview 플러그인을 가져옴.

https://pub.dev/packages/kakaomap_webview


기능
===========

구현
----------

- 마커 설정


미구현
---------

- 지도 클릭으로 마커 생성하기
- 마커 여러개 불러오기
- 마커에 데이터 저장
- 마커 클릭 시 데이터 불러오기


#설정
--------------------

## Android

- AndroidManifest.xml

android:usesCleartextTraffic="true" 추가.

```xml
    <application
        android:name="io.flutter.app.FlutterApplication"
        android:label="kakao_map_practice"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true">
```

## IOS

- Info.plist

파일 아래부분에 추가.

```plist
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
  <key>NSAllowsArbitraryLoadsInWebContent</key>
  <true/>
</dict>
```


WebView 속성
============

javascriptMode
----------

자바스크립트를 선택적으로 사용하거나 중지할 수 있음.

JavascriptMode.unrestricted (활성화)
JavascriptMode.disabled (비활성화);기본값


void Function(WebViewController)? onWebViewCreated
------------

Flutter에서 WebView를 프로그래밍 방식으로 수정하거나 현재 표시되고 있는 URL과 같은 속성에 액세스 하기 위한 티켓.
나중에 볼 수 있도록 페이지를 즐겨찾기에 저장할 수 있는 기능 등.


gestureRecognizers
---

WebView가 동작에 응답하는 다른 위젯 (예: ListView) 내부에 있는 경우 앱이 동작에 응답하는 방식을
지정하려 할 때.

세로 방향의 스크롤 이벤트를 포착하려면 다음과 같이 작성할 수 있습니다.
```dart
WebView(
 initialUrl: someUrl,
 gestureRecognizers: Set()
   ..add(Factory<VerticalDragGestureRecognizer>(
     () => VerticalDragGestureRecognizer())),
)
```
또는 다음과 같이 다른 방식으로 작성할 수도 있습니다.
```dart
var verticalGestures = Factory<VerticalDragGestureRecognizer>(
 () => VerticalDragGestureRecognizer());
var gestureSet = Set.from([verticalGestures]);
return WebView(
 initialUrl: someUrl,
 gestureRecognizers: gestureSet,
);
``` 
- DoubleTapGestureRecognizer
 
 사용자가 같은 위치에서 화면을 빠르게 두 번 연속으로 탭한 경우를 인식
 
- MultiDragGestureRecognizer
 
 ImmediateMultiDragGestureRecognizer , 다중 포인터 드래그 제스쳐 인식.
 HorizontalMultiDragGestureRecognizer , 수평으로 시작하는 드래그만 인식.
 VerticalMultiDragGestureRecognizer , 수직으로 시작하는 드래그만 인식.
 DelayedMultiDragGestureRecognizer , 길게 누르기 제스처 후에 시작되는 드래그만 인식.
 
- MultiTapGestureRecognizer
 https://api.flutter.dev/flutter/gestures/MultiTapGestureRecognizer-class.html
 
- OneSequenceGestureRecognizer
 
 한 번에 하나의 제스쳐만 인식 할 수 있는 제스처인식의 기본 클래스.
 
 예를 들어 단일 TapGestureRecognizer는 여러 포인터가 동일한 위젯에 배치되어 있어도
 동시에 발생하는 두 탭을 인식할 수 없다.
 
 이는, 예를 들어 각 포인터를 독립적으로 관리하고 별도의 탭에서 각 결과에 대한 여러 동시 터치를 고려할 수 있는
 MultiTapGestureRecognizer와 대조된다.
 
- DragGestureRecognizer
 
 MultiDragGestureRecognizer 와 달리 DragGestureRecognizer 는 
 감시하는 모든 포인터에 대해 단일 제스처 시퀀스를 인식합니다. 
 즉, 인식기는 화면과 접촉하는 포인터 수에 관계없이 주어진 시간에 최대 하나의 드래그 시퀀스를 활성화합니다.
 
 DragGestureRecognizer 는 직접 사용할 수 없습니다. 
 대신 드래그 제스처에 대한 특정 유형을 인식하기 위해 하위 클래스 중 하나를 사용하는 것이 좋습니다.
 
 DragGestureRecognizer 는 null이 아닌 콜백이 하나 이상있는 경우에만 
 kPrimaryButton의 포인터 이벤트에서 경쟁합니다 . 
 콜백이없는 경우 작동하지 않습니다.
 
	HorizontalDragGestureRecognizer , 왼쪽 및 오른쪽 끌기 용.
	VerticalDragGestureRecognizer , 위아래로 끌기.
	PanGestureRecognizer , 단일 축에 고정되지 않은 드래그 용.
 
- EagerGestureRecognizer
 
 일반적으로 뷰 경계 내의 모든 터치 이벤트를 
내장 된 Android 뷰로 즉시 전달하기 위해 AndroidView.gestureRecognizers 에 전달.
 
 - ForcePressGestureRecognizer
 
 압력에 의한 터치
 https://api.flutter.dev/flutter/gestures/ForcePressGestureRecognizer-class.html
 
- PrimaryPointerGestureRecognizer
 
 제스쳐가 영역 밖으로 나갈 경우 제스쳐 중지.
 
- ScaleGestureRecognizer
 
 화면과 접촉하는 포인터를 추적하고 초점, 표시된 배율 및 회전을 계산


### #참조
https://developers-kr.googleblog.com/2019/05/the-power-of-webviews-in-flutter.html