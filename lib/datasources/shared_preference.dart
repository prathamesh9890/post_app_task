import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';

class PostLocalDataSource {
  static const String _postsKey = 'cached_posts';
  static const String _readPostsKey = 'read_post_ids';

  final SharedPreferences prefs;

  PostLocalDataSource({required this.prefs});

  Future<void> cachePosts(List<PostModel> posts) async {
    final listJson = posts.map((e) => e.toJson()).toList();
    await prefs.setString(_postsKey, json.encode(listJson));
  }

  Future<List<PostModel>> getCachedPosts() async {
    final jsonString = prefs.getString(_postsKey);
    if (jsonString == null) return [];
    try {
      final List<dynamic> decoded = json.decode(jsonString);
      return decoded.map((e) => PostModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<Set<int>> getReadPostIds() async {
    final list = prefs.getStringList(_readPostsKey);
    if (list == null) return {};
    return list.map(int.parse).toSet();
  }

  Future<void> saveReadPostIds(Set<int> ids) async {
    final list = ids.map((e) => e.toString()).toList();
    await prefs.setStringList(_readPostsKey, list);
  }
}
