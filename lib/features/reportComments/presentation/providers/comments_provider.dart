import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/comment_model.dart';
import '../../data/repositories/comments_repository_impl.dart';

final commentsProvider =
    AsyncNotifierProviderFamily<CommentsNotifier, List<CommentModel>, String>(
      CommentsNotifier.new,
    );

class CommentsNotifier extends FamilyAsyncNotifier<List<CommentModel>, String> {
  @override
  Future<List<CommentModel>> build(String reportId) async {
    return ref.watch(commentsRepositoryProvider).getCommentsByReport(reportId);
  }

  Future<void> addComment(String content) async {
    final repository = ref.read(commentsRepositoryProvider);
    final newComment = await repository.createComment(
      content: content,
      reportId: arg,
    );
    state = state.whenData((comments) => [newComment, ...comments]);
  }

  Future<void> replyToComment(String parentId, String content) async {
    final repository = ref.read(commentsRepositoryProvider);
    await repository.createComment(
      content: content,
      reportId: arg,
      parentId: parentId,
    );
    // Refresh to get nested comments updated
    ref.invalidateSelf();
  }

  Future<void> toggleLike(String commentId) async {
    final repository = ref.read(commentsRepositoryProvider);
    await repository.toggleLike(commentId);
    // Optimistic UI update or invalidate
    ref.invalidateSelf();
  }
}
