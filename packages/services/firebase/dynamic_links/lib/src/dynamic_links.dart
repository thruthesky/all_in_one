import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';

class DynamicLinks {
  static DynamicLinks? _instance;
  static DynamicLinks get instance {
    /// if `_instance` is null, it will return new DynamicLinks() instance.
    return _instance ??= DynamicLinks();
  }

  String _dynamicLinkDomain = '';
  String _dynamicLinkWebDomain = '';

  String _androidAppId = '';
  String _iosBundleId = '';

  int _androidMinimumVersion = 0;
  String _iosMinimumVersion = '0';

  /// Initializes the service.
  ///
  /// [dynamicLinkDomain] this must be the same dynamic link domain registered on your firebase console.
  ///
  /// [dynamicLinkWebDomain] this must be a valid domain, when ever a user generated a link,
  /// this will be used as a redirect on desktop web browsers.
  ///
  /// [androidAppId] android package name can be found at "android/app/build.grade" defaultConfig.applicationId.
  ///
  /// [iosBundleId]
  ///
  /// [androidMinimumVersion] and [iosMinimumVersion] sets which application minimum version to support dynamic links.
  ///
  /// [uriHandler] returns dynamic link Uri.
  ///
  /// [errorHandler] returns error with code and message.
  ///
  /// ``` dart
  /// DynamicLinks.instance.init(
  ///     dynamicLinkDomain: 'https://sample.page.link',
  ///     dynamicLinkWebDomain: 'https://ww.sample.com',
  ///     androidAppId: 'com.sample.app',
  ///     uriHandler: (uri) => print(uri.toString()),
  /// );
  /// ```
  Future<void> init({
    required dynamicLinkDomain,
    required dynamicLinkWebDomain,
    String androidAppId = '',
    String iosBundleId = '',
    int androidMinimumVersion = 0,
    String iosMinimumVersion = '0',
    required Function(Uri)? uriHandler,
    Function(String)? errorHandler,
  }) async {
    _dynamicLinkDomain = dynamicLinkDomain;
    _dynamicLinkWebDomain = dynamicLinkWebDomain;
    _androidAppId = androidAppId;
    _androidMinimumVersion = androidMinimumVersion;
    _iosBundleId = iosBundleId;
    _iosMinimumVersion = iosMinimumVersion;

    /// Initialize dynamic link listeners
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        if (uriHandler != null) uriHandler(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      if (errorHandler != null) {
        errorHandler('${e.code}: ${e.message}');
      } else {
        if (kDebugMode) print(e.toString());
      }
    });

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      if (uriHandler != null) uriHandler(deepLink);
    }
  }

  /// Create dynamic link
  ///
  /// [short] true by default.
  /// [path] must be a valid Uri path including the "/", it can also includes query.
  ///
  /// [webDomain] web domain that the dynamic link will redirect besides the default [dynamicLinkWebDomain]
  /// initially set on `init()`, [webDomain] must also be included on the URL whitelist on firebase console dynamic links settings.
  ///
  /// [title], [description] and [imageUrl] can be provided for social meta tags.
  /// 
  /// [campaign], [source], [medium], [content] and [term] are used for google analytics.
  /// ``` dart
  ///   DynamicLinks.instance.create(
  ///     path: '/forum?postIdx=123',
  ///     title: 'sample title',
  ///     description: 'this is content',
  ///     imageUrl: '...',
  ///   )
  /// ```
  Future<Uri> create({
    bool short = true,
    String path = '',
    String? webDomain,
    String? title,
    String? description,
    String? imageUrl,
    String? campaign,
    String? source,
    String? medium,
    String? content,
    String? term,
  }) async {
    String _link = '$_dynamicLinkWebDomain';
    if (webDomain != null) _link = webDomain;
    if (path != '') _link = '$_link$path';

    DynamicLinkParameters parameters = DynamicLinkParameters(
      /// this should be the same as the one on the firebase console.
      uriPrefix: _dynamicLinkDomain,
      link: Uri.parse(_link),

      /// android package name can be found at "android/app/build.grade" defaultConfig.applicationId.
      /// set which application minimum version to support dynamic links.
      androidParameters: AndroidParameters(
        packageName: _androidAppId,
        minimumVersion: _androidMinimumVersion,
      ),

      /// iOs application bundle ID.
      /// set which application minimum version to support dynamic links.
      iosParameters: IosParameters(
        bundleId: _iosBundleId,
        minimumVersion: _iosBundleId != '' ? _iosMinimumVersion : null,
      ),

      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        description: description,
        imageUrl: imageUrl != null ? Uri.parse(imageUrl) : null,
      ),

      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: campaign != null ? campaign : '',
        source: source != null ? source : '',
        medium: medium != null ? medium : '',
        content: content,
        term: term,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    return url;
  }
}
