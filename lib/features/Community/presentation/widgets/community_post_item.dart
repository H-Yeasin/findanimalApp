import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../data/models/chat_model.dart';
import '../screens/comment_show.dart';
import 'community_video_player.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class CommunityPostItem extends StatelessWidget {
  const CommunityPostItem({
    super.key,
    required this.chat,
    required this.time,
    required this.color,
    required this.allChats,
    required this.onShowReactions,
    required this.onToggleLike,
  });

  final ChatModel chat;
  final String time;
  final Color color;
  final List<ChatModel> allChats;
  final void Function(BuildContext context, String chatId) onShowReactions;
  final ValueChanged<String> onToggleLike;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name =
        '${chat.user.firstName.toLowerCase()}_${chat.user.lastName.toLowerCase()}';
    final profileUrl = chat.user.profileImage?.secureUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                backgroundImage: profileUrl != null
                    ? CachedNetworkImageProvider(profileUrl)
                    : null,
                child: profileUrl == null
                    ? Icon(Icons.person, size: 15, color: color)
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: AppTextStyles.body.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              time,
              style: AppTextStyles.body.copyWith(color: color.withValues(alpha: 0.5), fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(chat.content, style: AppTextStyles.body.copyWith(color: color, fontSize: 12, height: 1.3)),
        if (chat.media != null && chat.media!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: chat.media!.first.type == 'video'
                  ? VideoPlayerWidget(url: chat.media!.first.url)
                  : CachedNetworkImage(
                      imageUrl: chat.media!.first.url,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 150,
                        color: color.withValues(alpha: 0.1),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 150,
                        color: color.withValues(alpha: 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              color: color.withValues(alpha: 0.5),
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.imageUnavailable,
                              style: AppTextStyles.body.copyWith(
                                color: color.withValues(alpha: 0.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            GestureDetector(
              onLongPress: () => onShowReactions(context, chat.id),
              onTap: () => onToggleLike(chat.id),
              child: Row(
                children: [
                  Icon(Icons.thumb_up_alt_outlined, color: color, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    (chat.likesCount ?? 0).toString(),
                    style: AppTextStyles.body.copyWith(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            IconButton(
              icon: Icon(Icons.chat_bubble_outline, color: color, size: 18),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => CommentShowScreen(mainPost: chat),
                  ),
                );
              },
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
            const SizedBox(width: 4),
            Text(
              allChats.where((c) => c.replyTo?.id == chat.id).length.toString(),
              style: AppTextStyles.body.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
