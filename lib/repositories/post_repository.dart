import '../datasources/shared_preference.dart';
import '../datasources/post_remote_data_source.dart';
import '../models/post_model.dart';

class PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;

  PostRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<(List<PostModel>, bool)> getPostsWithCache() async {
    print("ddddddddddddddddddddddddddddddddddddddd");
    // Cache load
    final cache = await localDataSource.getCachedPosts();
    bool fromCache = cache.isNotEmpty;
    List<PostModel> result = cache;

    if (fromCache) {
      print("📦 Loaded ${cache.length} posts from cache.");
    } else {
      print("⚠ No cache found.");
    }

    try {
      print("🌍 Fetching latest posts from server...");
      final remote = await remoteDataSource.fetchPosts();

      print("✅ Successfully fetched ${remote.length} posts from API.");
      result = remote;
      fromCache = false;
      await localDataSource.cachePosts(remote);
    } catch (_) {
      print("❌ API request failed");
    }

    return (result, fromCache);
  }

  // Future<PostModel> getPostDetail(int id) {
  //   print("➡ Fetching details for Post ID: $id");
  //   return remoteDataSource.fetchPostDetail(id);
  // }
  Future<PostModel> getPostDetail(int id) async {
    print("Fetching details for Post ID: $id");

    try {
      final detail = await remoteDataSource.fetchPostDetail(id);
      print("Successfully fetched post detail for ID: $id");
      return detail;
    } catch (e) {
      print("❌ Failed to fetch detail for Post ID: $id — $e");
      rethrow;
    }
  }


  Future<Set<int>> getReadPostIds() => localDataSource.getReadPostIds();

  Future<void> saveReadPostIds(Set<int> ids) =>
      localDataSource.saveReadPostIds(ids);

}
