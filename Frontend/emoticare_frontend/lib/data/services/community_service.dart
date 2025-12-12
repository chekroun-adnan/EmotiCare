import '../../core/constants/endpoints.dart';
import '../../domain/repositories/community_repository.dart';
import '../api/dio_client.dart';
import '../models/community_post_model.dart';

class CommunityService implements CommunityRepository {
  CommunityService(this._client);

  final DioClient _client;

  @override
  Future<List<CommunityPostModel>> all() async {
    final res = await _client.client.get(Endpoints.communityAll);
    final list = (res.data as List<dynamic>? ?? [])
        .map((e) => CommunityPostModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  @override
  Future<CommunityPostModel> create(String userId, String text) async {
    final res = await _client.client.post(
      Endpoints.communityCreate,
      queryParameters: {'userId': userId, 'text': text},
    );
    return CommunityPostModel.fromJson(res.data as Map<String, dynamic>);
  }
}
