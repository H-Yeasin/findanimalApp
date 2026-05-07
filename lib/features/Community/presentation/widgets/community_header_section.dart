import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../data/models/story_model.dart';
import 'community_composer.dart';
import 'community_posting_indicator.dart';
import 'community_story_strip.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class CommunityHeaderSection extends StatelessWidget {
  const CommunityHeaderSection({
    super.key,
    required this.contentController,
    required this.selectedMedia,
    required this.storiesAsync,
    required this.isUnauthorizedError,
    required this.onPickImage,
    required this.onPickVideo,
    required this.onPickFile,
    required this.onRemoveMedia,
    required this.onSubmitPost,
    required this.onShareStory,
  });

  final TextEditingController contentController;
  final List<File> selectedMedia;
  final AsyncValue<List<StoryModel>> storiesAsync;
  final bool Function(Object err) isUnauthorizedError;
  final VoidCallback onPickImage;
  final VoidCallback onPickVideo;
  final VoidCallback onPickFile;
  final ValueChanged<int> onRemoveMedia;
  final VoidCallback onSubmitPost;
  final VoidCallback onShareStory;

  static const _brandPrimary = Color(0xFFBA4A22);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Text(
          l10n.communityTitle,
          style: AppTextStyles.body.copyWith(
            fontSize: 24,
            color: _brandPrimary,
            fontFamily: 'EricaOne',
          ),
        ),
        const SizedBox(height: 20),
        CommunityComposer(
          contentController: contentController,
          selectedMedia: selectedMedia,
          pictureLabel: l10n.picture,
          videoLabel: l10n.video,
          fileLabel: l10n.file,
          mindHint: l10n.mindHint,
          onPickImage: onPickImage,
          onPickVideo: onPickVideo,
          onPickFile: onPickFile,
          onRemoveMedia: onRemoveMedia,
          onSubmitPost: onSubmitPost,
        ),
        const SizedBox(height: 20),
        CommunityStoryStrip(
          storiesAsync: storiesAsync,
          isUnauthorizedError: isUnauthorizedError,
          onShareStory: onShareStory,
        ),
        const SizedBox(height: 15),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            color: _brandPrimary,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Text(
                l10n.findFriend,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const CommunityPostingIndicator(),
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
    );
  }
}
