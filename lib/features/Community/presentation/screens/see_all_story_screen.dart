import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import '../../data/models/story_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class SeeAllStoryScreen extends ConsumerStatefulWidget {
  final List<List<StoryModel>> userStoryGroups;
  final int initialUserIndex;

  const SeeAllStoryScreen({
    super.key,
    required this.userStoryGroups,
    this.initialUserIndex = 0,
  });

  @override
  ConsumerState<SeeAllStoryScreen> createState() => _SeeAllStoryScreenState();
}

class _SeeAllStoryScreenState extends ConsumerState<SeeAllStoryScreen> {
  late PageController _userPageController;
  int _currentUserIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentUserIndex = widget.initialUserIndex;
    _userPageController = PageController(initialPage: _currentUserIndex);
  }

  @override
  void dispose() {
    _userPageController.dispose();
    super.dispose();
  }

  void _onUserStoryComplete() {
    if (_currentUserIndex + 1 < widget.userStoryGroups.length) {
      _userPageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _userPageController,
        itemCount: widget.userStoryGroups.length,
        onPageChanged: (index) {
          setState(() {
            _currentUserIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return UserStoryGroupViewer(
            stories: widget.userStoryGroups[index],
            onComplete: _onUserStoryComplete,
            onClose: () => Navigator.of(context).pop(),
          );
        },
      ),
    );
  }
}

class UserStoryGroupViewer extends ConsumerStatefulWidget {
  final List<StoryModel> stories;
  final VoidCallback onComplete;
  final VoidCallback onClose;

  const UserStoryGroupViewer({
    super.key,
    required this.stories,
    required this.onComplete,
    required this.onClose,
  });

  @override
  ConsumerState<UserStoryGroupViewer> createState() =>
      _UserStoryGroupViewerState();
}

class _UserStoryGroupViewerState extends ConsumerState<UserStoryGroupViewer>
    with TickerProviderStateMixin {
  late PageController _storyPageController;
  late AnimationController _animController;
  VideoPlayerController? _videoController;
  int _currentStoryIndex = 0;
  double _dragOffset = 0.0;
  final List<Widget> _floatingReactions = [];

  @override
  void initState() {
    super.initState();
    _storyPageController = PageController();
    _animController = AnimationController(vsync: this);

    _loadStory(story: widget.stories[_currentStoryIndex]);

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });
  }

  @override
  void dispose() {
    _storyPageController.dispose();
    _animController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _loadStory({required StoryModel story}) {
    _animController.stop();
    _animController.reset();
    _videoController?.dispose();
    _videoController = null;

    if (story.media.type == 'video') {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(story.media.url))
            ..initialize().then((_) {
              if (mounted) {
                setState(() {});
                _animController.duration = _videoController!.value.duration;
                _videoController!.play();
                _animController.forward();
              }
            });
    } else {
      _animController.duration = const Duration(seconds: 5);
      _animController.forward();
    }
  }

  void _nextStory() {
    if (_currentStoryIndex + 1 < widget.stories.length) {
      setState(() {
        _currentStoryIndex++;
        _loadStory(story: widget.stories[_currentStoryIndex]);
      });
      _storyPageController.animateToPage(
        _currentStoryIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.linear,
      );
    } else {
      widget.onComplete();
    }
  }

  void _previousStory() {
    if (_currentStoryIndex - 1 >= 0) {
      setState(() {
        _currentStoryIndex--;
        _loadStory(story: widget.stories[_currentStoryIndex]);
      });
      _storyPageController.animateToPage(
        _currentStoryIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.linear,
      );
    }
  }

  void _onTapDown(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      _previousStory();
    } else if (dx > 2 * screenWidth / 3) {
      _nextStory();
    }
  }

  void _handleReaction(String emoji) {
    setState(() {
      _floatingReactions.add(
        _FloatingEmoji(
          emoji: emoji,
          onComplete: () {
            if (mounted) {
              setState(() {
                if (_floatingReactions.isNotEmpty) {
                  _floatingReactions.removeAt(0);
                }
              });
            }
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final authSession = ref.watch(authSessionProvider);
    final story = widget.stories[_currentStoryIndex];
    final currentUserId = authSession.value?.user?.id;
    final bool isMyStory = currentUserId == story.user.id;

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          _dragOffset += details.primaryDelta!;
        });
      },
      onVerticalDragEnd: (details) {
        if (_dragOffset > 150) {
          widget.onClose();
        } else {
          setState(() {
            _dragOffset = 0.0;
          });
        }
      },
      onTapDown: _onTapDown,
      onLongPressStart: (_) {
        _animController.stop();
        _videoController?.pause();
      },
      onLongPressEnd: (_) {
        _animController.forward();
        _videoController?.play();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(
          0,
          _dragOffset > 0 ? _dragOffset : 0,
          0,
        ),
        color: Colors.black,
        child: Stack(
          children: [
            // Media Content
            PageView.builder(
              controller: _storyPageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              itemBuilder: (context, index) {
                final s = widget.stories[index];
                if (s.media.type == 'video') {
                  if (_videoController != null &&
                      _videoController!.value.isInitialized) {
                    return Center(
                      child: AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                return CachedNetworkImage(
                  imageUrl: s.media.url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),

            // Top Gradient & Info
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Progress Bars
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Row(
                        children: widget.stories.asMap().entries.map((entry) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: AnimatedBuilder(
                                animation: _animController,
                                builder: (context, child) {
                                  return LinearProgressIndicator(
                                    value: entry.key == _currentStoryIndex
                                        ? _animController.value
                                        : (entry.key < _currentStoryIndex
                                              ? 1.0
                                              : 0.0),
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.3,
                                    ),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                    minHeight: 2,
                                  );
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // User Profile
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: story.user.profileImage != null
                                ? CachedNetworkImageProvider(
                                    story.user.profileImage!.secureUrl,
                                  )
                                : null,
                            child: story.user.profileImage == null
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${story.user.firstName} ${story.user.lastName}',
                                  style: AppTextStyles.body.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (story.caption != null &&
                                    story.caption != ".")
                                  Text(
                                    story.caption!,
                                    style: AppTextStyles.body.copyWith(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: widget.onClose,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Reactions (only for others)
            if (!isMyStory)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: ['👍', '❤️', '😂', '😮', '😢', '😡'].map((
                        emoji,
                      ) {
                        return GestureDetector(
                          onTap: () => _handleReaction(emoji),
                          child: Text(
                            emoji,
                            style: AppTextStyles.body.copyWith(fontSize: 32),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

            // Floating Emoji Animation Layer
            ..._floatingReactions,
          ],
        ),
      ),
    );
  }
}

class _FloatingEmoji extends StatefulWidget {
  final String emoji;
  final VoidCallback onComplete;

  const _FloatingEmoji({required this.emoji, required this.onComplete});

  @override
  State<_FloatingEmoji> createState() => _FloatingEmojiState();
}

class _FloatingEmojiState extends State<_FloatingEmoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _yAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _yAnimation = Tween<double>(
      begin: 0,
      end: -400,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_controller);

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          bottom: 100 - _yAnimation.value,
          right: 20,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Text(widget.emoji, style: AppTextStyles.body.copyWith(fontSize: 40)),
          ),
        );
      },
    );
  }
}
