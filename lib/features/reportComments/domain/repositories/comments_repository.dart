import '../../data/models/comment_model.dart';

abstract class CommentsRepository {
  Future<List<CommentModel>> getCommentsByReport(String reportId);

  Future<CommentModel> createComment({
    required String content,
    required String reportId,
    String? parentId,
  });

  Future<void> toggleLike(String commentId);
}
