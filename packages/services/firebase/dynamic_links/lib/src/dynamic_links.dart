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
  /// this will used as a redirect on desktop web browsers.
  ///
  /// [androidAppId] android package name can be found at "android/app/build.grade" defaultConfig.applicationId.
  ///
  /// [iosBundleId]
  ///
  /// [androidMinimumVersion] and [iosMinimumVersion] sets which application minimum version to support dynamic links.
  ///
  /// [uriHandler] returns dynamic link Uri.
  ///
  /// [errorHandler] returns `OnLinkErrorException` object on error.
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
    Function(OnLinkErrorException)? errorHandler,
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
        errorHandler(e);
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
  /// [title], [description] and [imageUrl] can be provided for social meta tags.
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
    String? title,
    String? description,
    String? imageUrl,
  }) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      /// this should be the same as the one on the firebase console.
      uriPrefix: _dynamicLinkDomain,
      link: Uri.parse('$_dynamicLinkWebDomain$path'),
      // googleAnalyticsParameters: GoogleAnalyticsParameters(),

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
        minimumVersion: _iosMinimumVersion,
      ),

      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        description: description,
        imageUrl: imageUrl != null ? Uri.parse(imageUrl) : null,
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
