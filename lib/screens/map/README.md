# kakaomap_webview 플러그인을 가져옴.



# 설정

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