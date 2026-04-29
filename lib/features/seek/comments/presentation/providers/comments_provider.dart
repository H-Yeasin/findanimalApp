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
    // Logic to add comment will go here
  }
}
