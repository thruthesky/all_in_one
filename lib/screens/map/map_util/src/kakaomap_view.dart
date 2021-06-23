import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KakaoMapView extends StatelessWidget {
  /// Map width. If width is wider than screen size, the map center can be changed
  final double width;

  /// Map height
  final double height;

  /// latitude
  final double lat;

  /// longitude
  final double lng;

  /// Kakao map key javascript key
  final String kakaoMapKey;

  /// If it's true, zoomController will be enabled
  final bool showZoomControl;

  /// If it's true, mapTypeController will be enabled. Such as normal map, sky view
  final bool showMapTypeControl;

  /// Set marker image. If it's null, default marker will be showing
  final String markerImageURL;

  /// marker tap event
  final void Function(JavascriptMessage)? onTapMarker;

  /// This is used to make your own features.
  /// Only map size and center position is set.
  /// And other optional features won't work.
  /// such as Zoom, MapType, markerImage, onTapMarker
  final String? customScript;

  /// When you want to use key for the widget to get some features
  /// such as position, size, etc you can use this
  final GlobalKey? mapWidgetKey;

  KakaoMapView(
      {required this.width,
      required this.height,
      required this.kakaoMapKey,
      required this.lat,
      required this.lng,
      this.showZoomControl = false,
      this.showMapTypeControl = false,
      this.onTapMarker,
      this.markerImageURL = '',
      this.customScript,
      this.mapWidgetKey});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: mapWidgetKey,
      height: height,
      width: width,
      child: WebView(
          initialUrl: (customScript == null) ? _getHTML() : _customScriptHTML(),
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: onTapMarker == null
              ? null
              : Set.from([
                  JavascriptChannel(
                      name: 'onTapMarker', onMessageReceived: onTapMarker!)
                ]),
          debuggingEnabled: true,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
            Factory(() => EagerGestureRecognizer()),
          ].toSet()),
    );
  }

  String _getHTML() {
    String iosSetting = '';
    String markerImageOption = '';

    if (Platform.isIOS) {
      iosSetting = 'min-width:${width}px;min-height:${height}px;';
    }

    if (markerImageURL.isNotEmpty) {
      markerImageOption = 'image: markerImage';
    }

    return Uri.dataFromString('''
<html>
<header>
  <meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=yes\'>
</header>
<body style="padding:0; margin:0;">
	<div id='map' style="width:100%;height:100%;$iosSetting"></div>
	<script type="text/javascript" src='https://dapi.kakao.com/v2/maps/sdk.js?autoload=true&appkey=$kakaoMapKey'></script>
	<script>
		var container = document.getElementById('map');
		
		var options = {
			center: new kakao.maps.LatLng($lat, $lng),
			level: 3
		};
		var map = new kakao.maps.Map(container, options);
		
		if(${markerImageURL.isNotEmpty}){
		  var imageSrc = '$markerImageURL',
		      imageSize = new kakao.maps.Size(64, 69),
		      imageOption = {offset: new kakao.maps.Point(27, 69)},
		      markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
		}
		var markerPosition  = new kakao.maps.LatLng($lat, $lng);
		
		var marker = new kakao.maps.Marker({
      position: markerPosition,
      $markerImageOption
    });
    
    marker.setMap(map);
    
    if(${onTapMarker != null}){
      kakao.maps.event.addListener(marker, 'click', function(){
        onTapMarker.postMessage('marker is tapped');
      });
    }
		
		if($showZoomControl){
		  var zoomControl = new kakao.maps.ZoomControl();
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
    }
    
    if($showMapTypeControl){
      var mapTypeControl = new kakao.maps.MapTypeControl();
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
    }
	</script>
</body>
</html>
    ''', mimeType: 'text/html').toString();
  }

  String _customScriptHTML() {
    String iosSetting = '';

    if (Platform.isIOS) {
      iosSetting = 'min-width:${width}px;min-height:${height}px;';
    }

    return Uri.dataFromString('''
<html>
<header>
  <meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=yes\'>
</header>
<body style="padding:0; margin:0;">
	<div id='map' style="width:100%;height:100%;$iosSetting"></div>
	<script type="text/javascript" src='https://dapi.kakao.com/v2/maps/sdk.js?autoload=true&appkey=$kakaoMapKey'></script>
	<script>
		var container = document.getElementById('map');
		
		var options = {
			center: new kakao.maps.LatLng($lat, $lng),
			level: 3
		};
		
		$customScript
	</script>
</body>
</html>
    ''', mimeType: 'text/html').toString();
  }
}
