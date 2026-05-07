import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_provider.dart';

final commentsRemoteSourceProvider = Provider<CommentsRemoteSource>((ref) {
  return CommentsRemoteSource(ref.watch(apiClientProvider));
});

class CommentsRemoteSource {
  const CommentsRemoteSource(this._apiClient);

  final ApiClient _apiClient;

  Future<dynamic> getCommentsByReport(String reportId) async {
    final response = await _apiClient.get(
      '/comments/get-comments-by-report/$reportId',
    );
    return response.data;
  }

  Future<dynamic> createComment({
    required String content,
    required String reportId,
    String? parentId,
  }) async {
    final requestData = <String, dynamic>{
      'content': content,
      'reportId': reportId,
    };
    if (parentId != null) {
      requestData['parentId'] = parentId;
    }

    final response = await _apiClient.post(
      '/comments/create-comment',
      data: requestData,
    );
    return response.data;
  }

  Future<dynamic> toggleLike(String commentId) async {
    final response = await _apiClient.post('/comments/toggle-like/$commentId');
    return response.data;
  }
}
