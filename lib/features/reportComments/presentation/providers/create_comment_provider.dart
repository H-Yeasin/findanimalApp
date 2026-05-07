import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/comments_repository_impl.dart';

class CreateCommentNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit({
    required String content,
    required String reportId,
    String? parentId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(commentsRepositoryProvider).createComment(
            content: content,
            reportId: reportId,
            parentId: parentId,
          );
    });
  }
}

final createCommentProvider =
    AsyncNotifierProvider<CreateCommentNotifier, void>(
      CreateCommentNotifier.new,
    );
