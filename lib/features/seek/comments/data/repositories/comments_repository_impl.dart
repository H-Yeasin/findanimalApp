import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/comments_repository.dart';
import '../models/comment_model.dart';
import '../sources/comments_remote_source.dart';

final commentsRepositoryProvider = Provider<CommentsRepository>((ref) {
  return CommentsRepositoryImpl(ref.watch(commentsRemoteSourceProvider));
});

class CommentsRepositoryImpl implements CommentsRepository {
  const CommentsRepositoryImpl(this._remoteSource);

  final CommentsRemoteSource _remoteSource;

  @override
  Future<List<CommentModel>> getCommentsByReport(String reportId) async {
    final response = await _remoteSource.getCommentsByReport(reportId);
    final List<dynamic> data = response['data'] ?? [];
    return data
        .map((json) => CommentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CommentModel> createComment({
    required String content,
    required String reportId,
    String? parentId,
  }) async {
    final response = await _remoteSource.createComment(
      content: content,
      reportId: reportId,
      parentId: parentId,
    );
    return CommentModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}
