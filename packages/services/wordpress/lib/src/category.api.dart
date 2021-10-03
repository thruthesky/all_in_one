import 'package:wordpress/models/category.model.dart';
import 'package:wordpress/wordpress.dart';

class CategoryApi {
  /// Singleton
  static CategoryApi? _instance;
  static CategoryApi get instance {
    if (_instance == null) {
      _instance = CategoryApi();
    }
    return _instance!;
  }

  Future<List<WPCategory>> tree() async {
    final res = await WordpressApi.instance.request('category.tree');

    List<WPCategory> cats = [];
    for (final j in res) {
      cats.add(WPCategory.fromJson(j));
    }

    return cats;
  }
}
