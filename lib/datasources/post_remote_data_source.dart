import '../api_services/api_service.dart';
import '../api_services/urls.dart';
import '../models/post_model.dart';

class PostRemoteDataSource {

  Future<List<PostModel>> fetchPosts() async {
    final res = await ApiService.getRequest(postUrl);

    final List<dynamic> jsonList = res.data;
    return jsonList.map((e) => PostModel.fromJson(e)).toList();
  }


  Future<PostModel> fetchPostDetail(int postId) async {
    final res = await ApiService.getRequest("/posts/$postId");

    return PostModel.fromJson(res.data);
  }
}
