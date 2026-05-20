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
    required this.searchController,
    required this.onSearchChanged,
  });

  final TextEditingController contentController;
  final TextEditingController searchController;
  final List<File> selectedMedia;
  final AsyncValue<List<StoryModel>> storiesAsync;
  final bool Function(Object err) isUnauthorizedError;
  final VoidCallback onPickImage;
  final VoidCallback onPickVideo;
  final VoidCallback onPickFile;
  final ValueChanged<int> onRemoveMedia;
  final VoidCallback onSubmitPost;
  final VoidCallback onShareStory;
  final ValueChanged<String> onSearchChanged;

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
        _CommunityFriendSearchBar(
          controller: searchController,
          hintText: l10n.findFriend,
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 18),
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

class _CommunityFriendSearchBar extends StatelessWidget {
  const _CommunityFriendSearchBar({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  static const _brandPrimary = Color(0xFFBA4A22);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 34,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: Colors.white,
        textAlignVertical: TextAlignVertical.center,
        style: AppTextStyles.body.copyWith(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: _brandPrimary,
          prefixIcon: const Icon(Icons.search, color: Colors.white, size: 16),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 38,
            minHeight: 34,
          ),
          hintText: hintText,
          hintStyle: AppTextStyles.body.copyWith(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
