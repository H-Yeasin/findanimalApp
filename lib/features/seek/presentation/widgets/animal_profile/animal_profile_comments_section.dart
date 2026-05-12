import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/core/utils/formatters.dart';
import 'package:hesteka_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:hesteka_frontend/features/reportComments/data/models/comment_model.dart';
import 'package:hesteka_frontend/features/reportComments/presentation/providers/comments_provider.dart';
import 'animal_profile_data.dart';

class AnimalProfileCommentsSection extends ConsumerStatefulWidget {
  final AnimalProfileData data;

  const AnimalProfileCommentsSection({super.key, required this.data});

  @override
  ConsumerState<AnimalProfileCommentsSection> createState() =>
      _AnimalProfileCommentsSectionState();
}

class _AnimalProfileCommentsSectionState
    extends ConsumerState<AnimalProfileCommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _replyingToCommentId;
  File? _selectedImage;
  bool _isUploading = false;

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty && _selectedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final notifier = ref.read(commentsProvider(widget.data.id).notifier);

      if (_replyingToCommentId != null) {
        await notifier.replyToComment(_replyingToCommentId!, text, image: _selectedImage);
      } else {
        await notifier.addComment(text, image: _selectedImage);
      }

      _commentController.clear();
      setState(() {
        _replyingToCommentId = null;
        _selectedImage = null;
        _isUploading = false;
      });
      _focusNode.unfocus();
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final commentsAsync = ref.watch(commentsProvider(widget.data.id));
    final currentUser = ref.watch(currentUserProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 34, 16, 16),
      child: Column(
        children: [
          // Title
          Text(
            l10n.latestInfo,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 26,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),

          commentsAsync.when(
            data: (comments) {
              if (comments.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    l10n.beTheFirstToHelp,
                    style: AppTextStyles.caption,
                  ),
                );
              }
              return Column(
                children: comments
                    .map(
                      (comment) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _CommentItem(
                          comment: comment,
                          currentUserId: currentUser?.id,
                          onLike: () => ref
                              .read(commentsProvider(widget.data.id).notifier)
                              .toggleLike(comment.id),
                          onReply: () {
                            setState(() {
                              _replyingToCommentId = comment.id;
                            });
                            _focusNode.requestFocus();
                          },
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(color: Color(0xFFBA4A22)),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                l10n.errorLoadingComments(error.toString()),
                style: AppTextStyles.caption.copyWith(
                  color: Colors.red,
                  fontSize: 10,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),
          // Replying indicator
          if (_replyingToCommentId != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 14),
              child: Row(
                children: [
                  Text(
                    l10n.replying,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _replyingToCommentId = null;
                      });
                      _focusNode.unfocus();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFFBA4A22),
                    ),
                  ),
                ],
              ),
            ),
          // Comment bar at bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFBA4A22),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selectedImage != null) ...[
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(2),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        focusNode: _focusNode,
                        style: AppTextStyles.caption.copyWith(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: l10n.commentAs(
                            currentUser?.firstName ?? "User",
                          ),
                          hintStyle: AppTextStyles.caption.copyWith(
                            color: Colors.white70,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _submitComment(),
                      ),
                    ),
                    const SizedBox(width: 5),
                    _isUploading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : GestureDetector(
                            onTap: _submitComment,
                            child: const Icon(Icons.send, color: Colors.white, size: 18),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback? onLike;
  final VoidCallback? onReply;
  final String? currentUserId;

  const _CommentItem({
    required this.comment,
    this.onLike,
    this.onReply,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final authorName =
        '${comment.author.firstName.toLowerCase()}_${comment.author.lastName.toLowerCase()}';
    final l10n = AppLocalizations.of(context);
    final timeFormatted = l10n.text(
      'hoursAgo',
      params: {
        'hours': Formatters.date(
          comment.createdAt,
          pattern: 'h',
          locale: l10n.locale.languageCode,
        ),
      },
    ); // Using existing hoursAgo key

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFBA4A22).withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info row
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFBA4A22),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              Text(
                authorName,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                timeFormatted,
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFFD3A482),
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${comment.likes.length}',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 2),
              GestureDetector(
                onTap: onLike,
                child: Icon(
                  (currentUserId != null &&
                          comment.likes.contains(currentUserId))
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: const Color(0xFFBA4A22),
                  size: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Comment text
          if (comment.content.isNotEmpty)
            Text(
              '"${comment.content}"',
              style: AppTextStyles.caption.copyWith(
                fontSize: 11,
                height: 1.5,
                // fontWeight: FontWeight.w500,
              ),
            ),
          if (comment.image?.secureUrl != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: comment.image!.secureUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    height: 100,
                    color: Colors.grey[200],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 10),
          // I like / Reply
          Row(
            children: [
              GestureDetector(
                onTap: onLike,
                child: Text(
                  l10n.iLike,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: onReply,
                child: Text(
                  l10n.reply,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          // Replies if any
          if (comment.replies.isNotEmpty)
            ...comment.replies
                .map(
                  (reply) => Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _ReplyItem(reply: reply),
                  ),
                )
                // ignore: unnecessary_to_list_in_spreads
                .toList(),

          if (comment.replies.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: onReply,
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 11,
                      backgroundColor: Color(0xFFBA4A22),
                      child: Icon(Icons.person, color: Colors.white, size: 13),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.replyEllipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: Color(0xFFD3A482),
                          fontSize: 11,
                        ),
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

class _ReplyItem extends StatelessWidget {
  final CommentModel reply;

  const _ReplyItem({required this.reply});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Color(0xFFBA4A22),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 13),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF6ED),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (reply.content.isNotEmpty)
                  Text(
                    reply.content,
                    style: AppTextStyles.caption.copyWith(fontSize: 11),
                  ),
                if (reply.image?.secureUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: reply.image!.secureUrl,
                        fit: BoxFit.cover,
                        height: 100,
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
        ),
      ],
    );
  }
}
