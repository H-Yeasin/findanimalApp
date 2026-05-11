import 'dart:io';
import '../../../../core/network/paginated_response.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/story_model.dart';

abstract class CommunityRepository {
  Future<PaginatedResponse<StoryModel>> getLocalStories({Map<String, dynamic>? query});
  Future<PaginatedResponse<ChatModel>> getLocalChat({Map<String, dynamic>? query});

  // Create actions
  Future<StoryModel> createStory({
    required String caption,
    required File media,
    double? lat,
    double? lng,
    String? address,
  });

  Future<ChatModel> createChat({
    required String content,
    List<File>? media,
    double? lat,
    double? lng,
    String? address,
    String? replyTo,
  });

  // Like actions
  Future<void> toggleChatLike(String chatId);
}
