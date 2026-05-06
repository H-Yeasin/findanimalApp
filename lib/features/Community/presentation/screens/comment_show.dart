import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../data/models/chat_model.dart';
import '../providers/community_providers.dart';
import '../widgets/community_video_player.dart';

class CommentShowScreen extends ConsumerStatefulWidget {
  final ChatModel mainPost;

  const CommentShowScreen({super.key, required this.mainPost});

  @override
  ConsumerState<CommentShowScreen> createState() => _CommentShowScreenState();
}

class _CommentShowScreenState extends ConsumerState<CommentShowScreen> {
  final TextEditingController _commentController = TextEditingController();
  final List<File> _selectedMedia = [];
  bool _isUploading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    final picker = ImagePicker();
    if (isVideo) {
      final XFile? video = await picker.pickVideo(source: source);
      if (video != null) {
        setState(() {
          _selectedMedia.add(File(video.path));
        });
      }
    } else {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedMedia.add(File(image.path));
        });
      }
    }
  }

  String _formatTimeAgo(DateTime? dateTime, AppLocalizations l10n) {
    if (dateTime == null) return l10n.justNow;
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 0) {
      return l10n.text('daysAgo', params: {'days': '${duration.inDays}'});
    }
    if (duration.inHours > 0) {
      return l10n.text('hoursAgo', params: {'hours': '${duration.inHours}'});
    }
    if (duration.inMinutes > 0) {
      return l10n.text('minutesAgo', params: {'minutes': '${duration.inMinutes}'});
    }
    return l10n.justNow;
  }

  @override
  Widget build(BuildContext context) {
    // Watch localChatProvider directly for real-time updates
    final chatsAsync = ref.watch(localChatProvider);
    final l10n = AppLocalizations.of(context);
    const brandPrimary = Color(0xFFBA4A22);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6E5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          l10n.comments,
          style: const TextStyle(
            color: brandPrimary,
            fontFamily: 'EricaOne',
            fontSize: 20,
          ),
        ),
        leading: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(
              color: brandPrimary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.undo, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
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
                          const SizedBox(width: 12),
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

          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(localChatProvider.future),
              color: brandPrimary,
              child: chatsAsync.when(
                data: (allChats) {
                  final comments = allChats
                      .where((chat) => chat.replyTo?.id == widget.mainPost.id)
                      .toList();

                  if (comments.isEmpty) {
                    return ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: Center(
                            child: Text(
                              l10n.noCommentsYet,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    itemCount: comments.length,
                    itemBuilder: (context, index) =>
                        _buildCommentItem(comments[index], brandPrimary),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: brandPrimary),
                ),
                error: (err, stack) => ListView(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(l10n.errorParam(err.toString())),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Media Preview Section
          if (_selectedMedia.isNotEmpty)
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              color: Colors.white,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedMedia.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(_selectedMedia[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 12,
                        top: 2,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedMedia.removeAt(index)),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.black54,
                            child: Icon(
                              Icons.close,
                              size: 12,
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

          // Comment Input Box (Facebook Style)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.image_outlined,
                          color: brandPrimary,
                          size: 28,
                        ),
                        onPressed: () => _pickMedia(ImageSource.gallery),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.videocam_outlined,
                          color: brandPrimary,
                          size: 28,
                        ),
                        onPressed: () =>
                            _pickMedia(ImageSource.gallery, isVideo: true),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            controller: _commentController,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: l10n.writeCommentHint,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      if (_isUploading)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      else
                        IconButton(
                          icon: const Icon(
                            Icons.send_rounded,
                            color: brandPrimary,
                            size: 28,
                          ),
                          onPressed: _handleSend,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSend() async {
    if (_commentController.text.trim().isEmpty && _selectedMedia.isEmpty) {
      return;
    }

    setState(() => _isUploading = true);
    try {
      // If content is empty but media is present, send a dot to satisfy backend
      final content =
          _commentController.text.trim().isEmpty && _selectedMedia.isNotEmpty
          ? "."
          : _commentController.text;

      await ref
          .read(communityActionProvider.notifier)
          .createChat(
            content: content,
            replyTo: widget.mainPost.id,
            media: _selectedMedia.isNotEmpty ? _selectedMedia : null,
          );
      _commentController.clear();
      setState(() {
        _selectedMedia.clear();
        _isUploading = false;
      });
      // localChatProvider is invalidated automatically by createChat,
      // so the UI will rebuild in real-time.
    } catch (e) {
      setState(() => _isUploading = false);
    }
  }

  Widget _buildCommentItem(ChatModel comment, Color color) {
    final name = '${comment.user.firstName} ${comment.user.lastName}';
    final profileUrl = comment.user.profileImage?.secureUrl;
    final time = _formatTimeAgo(
      comment.createdAt,
      AppLocalizations.of(context),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[300],
            backgroundImage: profileUrl != null
                ? CachedNetworkImageProvider(profileUrl)
                : null,
            child: profileUrl == null
                ? const Icon(Icons.person, size: 20, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (comment.content.isNotEmpty)
                        Text(
                          comment.content,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),

                      // Comment Media
                      if (comment.media != null && comment.media!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: comment.media!.first.type == 'video'
                                ? VideoPlayerWidget(
                                    url: comment.media!.first.url,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: comment.media!.first.url,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    placeholder: (context, url) => Container(
                                      height: 100,
                                      color: Colors.grey[200],
                                    ),
                                  ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    time,
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
