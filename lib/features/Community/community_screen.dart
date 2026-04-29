import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/routing/route_names.dart';

import '../missions/mission_local.dart';
import 'presentation/providers/community_providers.dart';
import 'faq_community.dart';
import 'shelters.dart';
import 'veterinarians.dart';
import 'authorities.dart';
import 'partners.dart';
import 'data/models/chat_model.dart';
import 'data/models/story_model.dart';
import '../auth/presentation/providers/auth_provider.dart';
import 'package:video_player/video_player.dart';
import 'presentation/screens/see_all_story_screen.dart';
import 'presentation/screens/comment_show.dart';

final activeVideoProvider = StateProvider<String?>((ref) => null);

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final TextEditingController _contentController = TextEditingController();
  final List<File> _selectedMedia = [];
  final ImagePicker _picker = ImagePicker();

  bool _isUnauthorizedError(Object err) {
    final message = err.toString().toLowerCase();
    return message.contains('401') || message.contains('unauthorized');
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedMedia.add(File(image.path));
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _selectedMedia.add(File(video.path));
      });
    }
  }

  Future<void> _pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedMedia.add(File(result.files.single.path!));
      });
    }
  }

  Future<void> _submitPost() async {
    final l10n = AppLocalizations.of(context);
    final authStatus = ref.read(authStateProvider);
    if (authStatus != AuthStatus.authenticated) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pleaseLoginToPostCommunity)),
        );
        context.push(RouteNames.account);
      }
      return;
    }

    if (_contentController.text.trim().isEmpty && _selectedMedia.isEmpty) {
      return;
    }

    // If content is empty but media is present, send a dot to satisfy backend
    final content =
        _contentController.text.trim().isEmpty && _selectedMedia.isNotEmpty
        ? "."
        : _contentController.text;

    try {
      await ref
          .read(communityActionProvider.notifier)
          .createChat(
            content: content,
            media: _selectedMedia.isEmpty ? null : _selectedMedia,
          );
    } catch (e) {
      if (mounted) {
        final unauthorized = _isUnauthorizedError(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              unauthorized
                  ? l10n.pleaseLoginToPostCommunity
                  : l10n.couldNotPost,
            ),
          ),
        );
        if (unauthorized) {
          context.push(RouteNames.account);
        }
      }
      return;
    }

    // Refresh the list after successful post
    ref.invalidate(localChatProvider);

    _contentController.clear();
    setState(() {
      _selectedMedia.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.postSharedSuccess)));
    }
  }

  Future<void> _shareStory() async {
    final l10n = AppLocalizations.of(context);
    final authStatus = ref.read(authStateProvider);
    if (authStatus != AuthStatus.authenticated) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.pleaseLoginToShareStory)));
        context.push(RouteNames.account);
      }
      return;
    }

    // Show a choice between image and video
    final XFile? media = await showModalBottomSheet<XFile>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: Text(l10n.picture),
              onTap: () async {
                final file = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (context.mounted) Navigator.pop(context, file);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text(l10n.video),
              onTap: () async {
                final file = await _picker.pickVideo(
                  source: ImageSource.gallery,
                );
                if (context.mounted) Navigator.pop(context, file);
              },
            ),
          ],
        ),
      ),
    );

    if (media == null) return;

    if (!mounted) return;
    final String? caption = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(l10n.newStory, style: TextStyle(fontFamily: 'Impact')),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Add a caption...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text(l10n.post),
            ),
          ],
        );
      },
    );

    if (caption != null) {
      try {
        await ref
            .read(communityActionProvider.notifier)
            .createStory(caption: caption, media: File(media.path));
      } catch (e) {
        if (mounted) {
          final unauthorized = _isUnauthorizedError(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                unauthorized
                    ? l10n.pleaseLoginToShareStory
                    : l10n.couldNotShareStory,
              ),
            ),
          );
          if (unauthorized) {
            context.push(RouteNames.account);
          }
        }
        return;
      }

      // Refresh the list after successful story
      ref.invalidate(localStoriesProvider);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.storySharedSuccess)));
      }
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brandPrimary = Color(0xFFBA4A22);
    const boxBg = Color(0xFFFFF6E5);
    final l10n = AppLocalizations.of(context);

    final storiesAsync = ref.watch(localStoriesProvider);
    final chatAsync = ref.watch(localChatProvider);
    final profileImage = ref.watch(currentUserProvider)?.profileImage;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF4E9),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(localStoriesProvider);
          ref.invalidate(localChatProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 50),
              // Header
              AppTopBar(
                leftWidget: IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: brandPrimary,
                    size: 30,
                  ),
                  onPressed: () => context.push(RouteNames.mainNotifications),
                ),
                userImageUrl: profileImage,
              ),

              Text(
                l10n.communityTitle,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: brandPrimary,
                  fontFamily: 'Impact',
                ),
              ),
              const SizedBox(height: 20),

              // "What's going through your mind?" box
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: boxBg,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: brandPrimary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?q=80&w=100',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: TextField(
                              controller: _contentController,
                              decoration: InputDecoration(
                                hintText: l10n.mindHint,
                                hintStyle: TextStyle(
                                  color: brandPrimary.withValues(alpha: 0.5),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                color: brandPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: brandPrimary),
                          onPressed: _submitPost,
                        ),
                      ],
                    ),
                    if (_selectedMedia.isNotEmpty)
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedMedia.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 8.0,
                                    top: 8.0,
                                  ),
                                  child:
                                      _selectedMedia[index].path
                                              .toLowerCase()
                                              .endsWith('.mp4') ||
                                          _selectedMedia[index].path
                                              .toLowerCase()
                                              .endsWith('.mov')
                                      ? Container(
                                          width: 50,
                                          height: 50,
                                          color: brandPrimary.withValues(
                                            alpha: 0.1,
                                          ),
                                          child: const Icon(
                                            Icons.videocam,
                                            color: brandPrimary,
                                          ),
                                        )
                                      : Image.file(
                                          _selectedMedia[index],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => _selectedMedia.removeAt(index),
                                    ),
                                    child: const CircleAvatar(
                                      radius: 8,
                                      backgroundColor: brandPrimary,
                                      child: Icon(
                                        Icons.close,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionItem(
                          Icons.image,
                          l10n.picture,
                          brandPrimary,
                          onTap: _pickImage,
                        ),
                        _buildActionItem(
                          Icons.videocam,
                          l10n.video,
                          brandPrimary,
                          onTap: _pickVideo,
                        ),
                        _buildActionItem(
                          Icons.folder,
                          l10n.file,
                          brandPrimary,
                          onTap: _pickFile,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stories
              SizedBox(
                height: 110,
                child: storiesAsync.when(
                  data: (allStories) {
                    final now = DateTime.now();
                    final stories = allStories
                        .where((s) => s.expiresAt.isAfter(now))
                        .toList();
                    final currentUser = ref.watch(currentUserProvider);

                    // Group stories by user
                    final Map<String, List<StoryModel>> groupedStories = {};
                    for (var story in stories) {
                      final userId = story.user.id;
                      if (!groupedStories.containsKey(userId)) {
                        groupedStories[userId] = [];
                      }
                      groupedStories[userId]!.add(story);
                    }

                    // Sort userIds: current user's stories should come first
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
                        _buildStoryItem(
                          'Share a\nstory',
                          null,
                          brandPrimary,
                          onTap: _shareStory,
                        ),
                        ...userIds.map((userId) {
                          final userStories = groupedStories[userId]!;
                          final story = userStories
                              .first; // Use first story for thumbnail
                          final name =
                              '${story.user.firstName.toLowerCase()}${story.user.lastName.toLowerCase().substring(0, story.user.lastName.length > 3 ? 3 : story.user.lastName.length)}';

                          return _buildStoryItem(
                            name,
                            story.media.url,
                            brandPrimary,
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
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    children: [
                      _buildStoryItem(
                        'Share a\nstory',
                        null,
                        brandPrimary,
                        onTap: _shareStory,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: Text(
                            _isUnauthorizedError(err)
                                ? l10n.pleaseLoginToViewLocalChat
                                : l10n.couldNotLoadStories,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Find a friend search bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: brandPrimary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search, color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      l10n.findFriend,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Posting Indicator (Facebook Style)
              Builder(
                builder: (context) {
                  final actionState = ref.watch(communityActionProvider);
                  if (actionState is AsyncLoading) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                l10n.posting,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: LinearProgressIndicator(
                              color: Colors.blue,
                              backgroundColor: Color(0xFFE0E0E0),
                              minHeight: 4,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              Text(
                l10n.localCat,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: brandPrimary,
                ),
              ),
              const SizedBox(height: 10),

              // Posts List
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: boxBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: brandPrimary.withValues(alpha: 0.3),
                  ),
                ),
                child: chatAsync.when(
                  data: (chats) {
                    if (chats.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'Aucun message local pour le moment.',
                            style: TextStyle(
                              color: brandPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                    final posts = chats
                        .where((chat) => chat.replyTo == null)
                        .toList();

                    return Column(
                      children: posts.asMap().entries.map((entry) {
                        final index = entry.key;
                        final chat = entry.value;
                        final timeAgo = _formatTimeAgo(chat.createdAt);
                        return Column(
                          children: [
                            _buildPostItem(chat, timeAgo, brandPrimary, chats),
                            if (index < posts.length - 1)
                              const Divider(height: 30),
                          ],
                        );
                      }).toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        _isUnauthorizedError(err)
                            ? l10n.pleaseLoginToViewLocalChat
                            : l10n.couldNotLoadLocalChat,
                        style: const TextStyle(
                          color: brandPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // SEE LOCAL MISSIONS section
              const Text(
                'SEE LOCAL\nMISSIONS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: brandPrimary,
                  height: 0.9,
                ),
              ),
              const SizedBox(height: 20),

              // Map section
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Image.asset(
                    'assets/images/Map/map.png',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: -20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MissionLocalScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: brandPrimary,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'SEE FULL LIST',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              // FAQ Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Text(
                      'HERE THERE ARE NO\nQUESTIONS WITHOUT ANSWERS!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: brandPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const FAQCommunityScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: brandPrimary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'GO TO FAQ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1543269865-cbf427effbad?q=80&w=200',
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // CONTACTS Section
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?q=80&w=600',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.black.withValues(alpha: 0.4),
                  ),
                  Column(
                    children: [
                      const Text(
                        'CONTACTS',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        children: [
                          _buildContactButton(
                            context,
                            'SHELTERS',
                            const SheltersScreen(),
                          ),
                          _buildContactButton(
                            context,
                            'VETERINARIANS',
                            const VeterinariansScreen(),
                          ),
                          _buildContactButton(
                            context,
                            'AUTHORITIES',
                            const AuthoritiesScreen(),
                          ),
                          _buildContactButton(
                            context,
                            'PARTNERS',
                            const PartnersScreen(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(
    IconData icon,
    String label,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(
    String name,
    String? imageUrl,
    Color color, {
    VoidCallback? onTap,
  }) {
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
                    ? CachedNetworkImageProvider(imageUrl)
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

  Widget _buildPostItem(
    ChatModel chat,
    String time,
    Color color,
    List<ChatModel> allChats,
  ) {
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
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              time,
              style: TextStyle(
                color: color.withValues(alpha: 0.5),
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          chat.content,
          style: TextStyle(color: color, fontSize: 12, height: 1.3),
        ),
        if (chat.media != null && chat.media!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
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
                              'Image non disponible',
                              style: TextStyle(
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
              onLongPress: () => _showReactions(context, chat.id),
              onTap: () => ref
                  .read(communityActionProvider.notifier)
                  .toggleLike(chat.id),
              child: Row(
                children: [
                  Icon(Icons.thumb_up_alt_outlined, color: color, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    (chat.likesCount ?? 0).toString(),
                    style: TextStyle(
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
              style: TextStyle(
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

  void _showReactions(BuildContext context, String chatId) {
    final List<String> emojis = ['👍', '❤️', '😂', '😮', '😢', '😡'];

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
                    child: Text(emoji, style: const TextStyle(fontSize: 30)),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showReplyDialog(String chatId) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Reply to Post',
            style: TextStyle(fontFamily: 'Impact'),
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Write a comment...'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(communityActionProvider.notifier)
                    .createChat(content: controller.text, replyTo: chatId);
                Navigator.pop(context);
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactButton(
    BuildContext context,
    String label,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF6E5),
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFBA4A22),
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'À l\'instant';
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 0) {
      return 'Il y a ${duration.inDays} j';
    } else if (duration.inHours > 0) {
      return 'Il y a ${duration.inHours} h';
    } else if (duration.inMinutes > 0) {
      return 'Il y a ${duration.inMinutes} m';
    } else {
      return 'À l\'instant';
    }
  }
}

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final String url;
  const VideoPlayerWidget({super.key, required this.url});

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final cleanUrl = widget.url.trim();
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(cleanUrl));
      await _controller.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
      }
    } catch (e) {
      debugPrint("Video Error for $cleanUrl: $e");
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        height: 150,
        width: double.infinity,
        color: const Color(0xFFBA4A22).withValues(alpha: 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFBA4A22), size: 40),
            const SizedBox(height: 8),
            const Text(
              'Impossible de charger la vidéo',
              style: TextStyle(color: Color(0xFFBA4A22), fontSize: 12),
            ),
            TextButton(
              onPressed: _initializePlayer,
              child: const Text(
                'Réessayer',
                style: TextStyle(color: Color(0xFFBA4A22)),
              ),
            ),
          ],
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        height: 150,
        width: double.infinity,
        color: const Color(0xFFBA4A22).withValues(alpha: 0.1),
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFFBA4A22)),
        ),
      );
    }

    // Listen to active video changes
    final activeVideoUrl = ref.watch(activeVideoProvider);
    if (activeVideoUrl != widget.url && _controller.value.isPlaying) {
      _controller.pause();
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
            ref.read(activeVideoProvider.notifier).state = null;
          } else {
            // Set this as the active video
            ref.read(activeVideoProvider.notifier).state = widget.url;
            _controller.play();
          }
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          if (!_controller.value.isPlaying)
            const Icon(Icons.play_circle_fill, color: Colors.white70, size: 50),
          Positioned(
            bottom: 5,
            right: 5,
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
