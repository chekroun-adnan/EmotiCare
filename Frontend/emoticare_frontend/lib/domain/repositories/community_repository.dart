import '../../data/models/community_post_model.dart';

abstract class CommunityRepository {
  Future<List<CommunityPostModel>> all();
  Future<CommunityPostModel> create(String userId, String text);
}
