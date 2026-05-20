import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/features/Community/presentation/providers/community_providers.dart';
import 'package:hesteka_frontend/features/Community/presentation/widgets/community_reactions_dialog.dart';
import 'package:hesteka_frontend/features/Community/presentation/widgets/community_top_bar.dart';
import 'package:hesteka_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:hesteka_frontend/features/home/presentation/providers/home_providers.dart';
import '../mixins/community_screen_mixin.dart';
import 'community_feed_screen.dart';
import '../widgets/community_bottom_sections.dart';
import '../widgets/community_header_section.dart';
import '../widgets/community_post_list.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen>
    with CommunityScreenMixin {
  @override
  void initState() {
    super.initState();
    initializeLocation();
  }

  @override
  void dispose() {
    disposeLogic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brandPrimary = Color(0xFFBA4A22);
    final storiesAsync = ref.watch(localStoriesProvider);
    final chatAsync = ref.watch(localChatProvider);
    final profileImage = ref.watch(currentUserProvider)?.profileImage;
    final reportsAsync = ref.watch(homeReportsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF4E9),
      body: Column(
        children: [
          CommunityPinnedTopBar(
            brandPrimary: brandPrimary,
            profileImage: profileImage,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshCommunity,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: CommunityHeaderSection(
                      contentController: contentController,
                      selectedMedia: selectedMedia,
                      storiesAsync: storiesAsync,
                      isUnauthorizedError: isUnauthorizedError,
                      onPickImage: pickImage,
                      onPickVideo: pickVideo,
                      onPickFile: pickFile,
                      onRemoveMedia: removeSelectedMedia,
                      onSubmitPost: submitPost,
                      onShareStory: shareStory,
                      searchController: communitySearchController,
                      onSearchChanged: updateCommunitySearchQuery,
                    ),
                  ),
                  CommunityPostList(
                    chatsAsync: chatAsync,
                    isUnauthorizedError: isUnauthorizedError,
                    searchQuery: communitySearchQuery,
                    onShowReactions: (context, chatId) =>
                        CommunityReactionsDialog.show(context, ref, chatId),
                    maxPosts: 3,
                    onSeeMore: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              CommunityFeedScreen(onShareStory: shareStory),
                        ),
                      );
                    },
                    onToggleLike: (chatId) {
                      ref
                          .read(communityActionProvider.notifier)
                          .toggleLike(chatId);
                    },
                  ),
                  SliverToBoxAdapter(
                    child: CommunityBottomSections(
                      currentPosition: currentPosition,
                      markers: buildReportMarkers(),
                      hasReportsError: reportsAsync.hasError,
                      onMapCreated: (controller) => mapController = controller,
                      onCameraMove: (position) {
                        currentPosition = position.target;
                      },
                      onLocateMe: handleLocateMe,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
