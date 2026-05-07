import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/community_providers.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class CommunityReactionsDialog extends ConsumerWidget {
  const CommunityReactionsDialog({
    required this.chatId,
    super.key,
  });

  final String chatId;

  static void show(BuildContext context, WidgetRef ref, String chatId) {
    final emojis = [
      '\u{1F44D}',
      '\u2764\uFE0F',
      '\u{1F602}',
      '\u{1F62E}',
      '\u{1F622}',
      '\u{1F621}',
    ];

    showDialog(
      context: context,
      barrierColor: Colors.black12,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: emojis.map((emoji) {
                return GestureDetector(
                  onTap: () {
                    ref
                        .read(communityActionProvider.notifier)
                        .toggleLike(chatId);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(emoji, style: AppTextStyles.body.copyWith(fontSize: 30)),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This widget is primarily used via the static show method
    return const SizedBox.shrink();
  }
}
