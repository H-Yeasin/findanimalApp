import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../data/models/chat_model.dart';
import 'community_post_item.dart';

class CommunityPostList extends StatelessWidget {
  const CommunityPostList({
    super.key,
    required this.chatsAsync,
    required this.isUnauthorizedError,
    required this.onShowReactions,
    required this.onToggleLike,
  });

  final AsyncValue<List<ChatModel>> chatsAsync;
  final bool Function(Object err) isUnauthorizedError;
  final void Function(BuildContext context, String chatId) onShowReactions;
  final ValueChanged<String> onToggleLike;

  static const _brandPrimary = Color(0xFFBA4A22);
  static const _boxBg = Color(0xFFFFF6E5);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return chatsAsync.when(
      data: (chats) {
        final posts = chats.where((chat) => chat.replyTo == null).toList();
        if (posts.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _boxBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _brandPrimary.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Text(
                  l10n.noLocalMessages,
                  style: const TextStyle(
                    color: _brandPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final chat = posts[index];
              final isFirst = index == 0;
              final isLast = index == posts.length - 1;

              return Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: _boxBg,
                  borderRadius: BorderRadius.vertical(
                    top: isFirst ? const Radius.circular(20) : Radius.zero,
                    bottom: isLast ? const Radius.circular(20) : Radius.zero,
                  ),
                  border: Border(
                    left: BorderSide(
                      color: _brandPrimary.withValues(alpha: 0.3),
                    ),
                    right: BorderSide(
                      color: _brandPrimary.withValues(alpha: 0.3),
                    ),
                    top: isFirst
                        ? BorderSide(
                            color: _brandPrimary.withValues(alpha: 0.3),
                          )
                        : BorderSide.none,
                    bottom: isLast
                        ? BorderSide(
                            color: _brandPrimary.withValues(alpha: 0.3),
                          )
                        : BorderSide.none,
                  ),
                ),
                child: Column(
                  children: [
                    CommunityPostItem(
                      chat: chat,
                      time: _formatTimeAgo(context, chat.createdAt),
                      allChats: chats,
                      color: _brandPrimary,
                      onShowReactions: onShowReactions,
                      onToggleLike: onToggleLike,
                    ),
                    if (!isLast) const Divider(height: 30),
                  ],
                ),
              );
            }, childCount: posts.length),
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              isUnauthorizedError(err)
                  ? l10n.pleaseLoginToViewLocalChat
                  : l10n.couldNotLoadLocalChat,
              style: const TextStyle(
                color: _brandPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(BuildContext context, DateTime? dateTime) {
    final l10n = AppLocalizations.of(context);
    if (dateTime == null) return l10n.justNow;
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 0) {
      return l10n.text('daysAgo', params: {'days': '${duration.inDays}'});
    } else if (duration.inHours > 0) {
      return l10n.text('hoursAgo', params: {'hours': '${duration.inHours}'});
    } else if (duration.inMinutes > 0) {
      return l10n.text('minutesAgo', params: {'minutes': '${duration.inMinutes}'});
    } else {
      return l10n.justNow;
    }
  }
}
