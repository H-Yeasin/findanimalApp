import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/community_providers.dart';
import '../widgets/community_post_list.dart';
import '../widgets/community_reactions_dialog.dart';
import '../widgets/community_story_strip.dart';

class CommunityFeedScreen extends ConsumerWidget {
  const CommunityFeedScreen({super.key, required this.onShareStory});

  final VoidCallback onShareStory;

  static const _brandPrimary = Color(0xFFBA4A22);

  bool _isUnauthorizedError(Object err) {
    final message = err.toString().toLowerCase();
    return message.contains('401') || message.contains('unauthorized');
  }

  Future<void> _refreshFeed(WidgetRef ref) async {
    await Future.wait([
      ref.refresh(localStoriesProvider.future),
      ref.refresh(localChatProvider.future),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final storiesAsync = ref.watch(localStoriesProvider);
    final chatsAsync = ref.watch(localChatProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF4E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF4E9),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: _brandPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.communityTitle,
          style: AppTextStyles.body.copyWith(
            color: _brandPrimary,
            fontFamily: 'EricaOne',
            fontSize: 22,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshFeed(ref),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 10),
                child: Column(
                  children: [
                    CommunityStoryStrip(
                      storiesAsync: storiesAsync,
                      isUnauthorizedError: _isUnauthorizedError,
                      onShareStory: onShareStory,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.localCat,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: _brandPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            CommunityPostList(
              chatsAsync: chatsAsync,
              isUnauthorizedError: _isUnauthorizedError,
              onShowReactions: (context, chatId) =>
                  CommunityReactionsDialog.show(context, ref, chatId),
              onToggleLike: (chatId) {
                ref.read(communityActionProvider.notifier).toggleLike(chatId);
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
