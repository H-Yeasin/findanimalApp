import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/story_model.dart';
import '../screens/see_all_story_screen.dart';

class CommunityStoryStrip extends ConsumerWidget {
  const CommunityStoryStrip({
    super.key,
    required this.storiesAsync,
    required this.isUnauthorizedError,
    required this.onShareStory,
  });

  final AsyncValue<List<StoryModel>> storiesAsync;
  final bool Function(Object err) isUnauthorizedError;
  final VoidCallback onShareStory;

  static const _brandPrimary = Color(0xFFBA4A22);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 110,
      child: storiesAsync.when(
        data: (allStories) {
          final now = DateTime.now();
          final stories = allStories
              .where((story) => story.expiresAt.isAfter(now))
              .toList();
          final currentUser = ref.watch(currentUserProvider);
          final groupedStories = <String, List<StoryModel>>{};

          for (final story in stories) {
            groupedStories.putIfAbsent(story.user.id, () => []).add(story);
          }

          final userIds = groupedStories.keys.toList();
          if (currentUser != null) {
            userIds.sort((a, b) {
              if (a == currentUser.id) return -1;
              if (b == currentUser.id) return 1;
              return 0;
            });
          }

          return ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: [
              _StoryItem(
                name: l10n.shareStoryShort,
                color: _brandPrimary,
                onTap: onShareStory,
              ),
              ...userIds.map((userId) {
                final userStories = groupedStories[userId]!;
                final story = userStories.first;
                final lastName = story.user.lastName.toLowerCase();
                final name =
                    '${story.user.firstName.toLowerCase()}${lastName.substring(0, lastName.length > 3 ? 3 : lastName.length)}';

                return _StoryItem(
                  name: name,
                  imageUrl: story.media.url,
                  color: _brandPrimary,
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => SeeAllStoryScreen(
                          userStoryGroups: userIds
                              .map((id) => groupedStories[id]!)
                              .toList(),
                          initialUserIndex: userIds.indexOf(userId),
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            _StoryItem(
              name: l10n.shareStoryShort,
              color: _brandPrimary,
              onTap: onShareStory,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  isUnauthorizedError(err)
                      ? l10n.pleaseLoginToViewLocalChat
                      : l10n.couldNotLoadStories,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  const _StoryItem({
    required this.name,
    required this.color,
    this.imageUrl,
    this.onTap,
  });

  final String name;
  final String? imageUrl;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: imageUrl == null
                    ? color.withValues(alpha: 0.1)
                    : null,
                backgroundImage: imageUrl != null
                    ? CachedNetworkImageProvider(imageUrl!)
                    : null,
                child: imageUrl == null ? Icon(Icons.add, color: color) : null,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
