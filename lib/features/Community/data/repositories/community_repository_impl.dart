import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/network/paginated_response.dart';
import '../../domain/repositories/community_repository.dart';
import '../models/chat_model.dart';
import '../models/story_model.dart';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepositoryImpl(ref.watch(apiClientProvider));
});

class CommunityRepositoryImpl implements CommunityRepository {
  const CommunityRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<PaginatedResponse<StoryModel>> getLocalStories({
    Map<String, dynamic>? query,
  }) async {
    final response = await _apiClient.get(
      '/community/stories/local',
      queryParameters: query,
    );

    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => StoryModel.fromJson(json),
    );
  }

  @override
  Future<PaginatedResponse<ChatModel>> getLocalChat({
    Map<String, dynamic>? query,
  }) async {
    final response = await _apiClient.get(
      '/community/chat/local',
      queryParameters: query,
    );

    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => ChatModel.fromJson(json),
    );
  }

  @override
  Future<StoryModel> createStory({
    required String caption,
    required File media,
    double? lat,
    double? lng,
    String? address,
  }) async {
    final data = <String, dynamic>{
      'caption': caption,
      'media': await MultipartFile.fromFile(media.path),
    };

    if (lat != null && lng != null) {
      data['lat'] = lat;
      data['lng'] = lng;
    }
    if (address != null && address.isNotEmpty) {
      data['address'] = address;
    }

    final formData = FormData.fromMap(data);

    final response = await _apiClient.post(
      '/community/stories/',
      data: formData,
    );
    return StoryModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<ChatModel> createChat({
    required String content,
    List<File>? media,
    double? lat,
    double? lng,
    String? address,
    String? replyTo,
  }) async {
    final data = <String, dynamic>{'content': content};

    if (lat != null && lng != null) {
      data['lat'] = lat;
      data['lng'] = lng;
    }
    if (address != null && address.isNotEmpty) {
      data['address'] = address;
    }
    if (replyTo != null && replyTo.isNotEmpty) {
      data['replyTo'] = replyTo;
    }

    if (media != null && media.isNotEmpty) {
      final List<MultipartFile> files = [];
      for (final file in media) {
        files.add(await MultipartFile.fromFile(file.path));
      }
      data['media'] = files;
    }

    final formData = FormData.fromMap(data);

    final response = await _apiClient.post('/community/chat/', data: formData);
    return ChatModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> toggleChatLike(String chatId) async {
    await _apiClient.post('/community/chat/$chatId/toggle');
  }
}
