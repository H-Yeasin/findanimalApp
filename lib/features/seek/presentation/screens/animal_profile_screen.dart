import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../comments/presentation/providers/comments_provider.dart';
import '../../comments/data/models/comment_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AnimalProfileData {
  final String id;
  final String name;
  final String details;
  final String time;
  final String status;
  final String description;
  final String imageUrl;
  final String ownerName;
  final bool isPlaceholder;

  AnimalProfileData({
    required this.id,
    required this.name,
    required this.details,
    required this.time,
    required this.status,
    required this.description,
    required this.imageUrl,
    required this.ownerName,
    this.isPlaceholder = false,
  });
}

class AnimalProfileScreen extends ConsumerWidget {
  final AnimalProfileData data;

  const AnimalProfileScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6ED),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        children: [
                          // === OUTER WRAPPER CARD ===
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5E4CE),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFFBA4A22),
                                width: 1.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildProfileCard(),
                                  _buildMapSection(),
                                  _buildLatestInfoSection(ref),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════ HEADER ═══════════════════════════
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFBA4A22),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.undo, color: Colors.white, size: 24),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFBA4A22),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════ PROFILE CARD ═══════════════════════════
  Widget _buildProfileCard() {
    String buttonText = 'Contact the owner';
    if (data.details.toLowerCase().contains('found')) {
      buttonText = 'I know the owner';
    }
    if (data.status.toLowerCase().contains('injured')) {
      buttonText = 'I am available to take care of it';
    }

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === TOP ROW: image left + info right ===
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── LEFT: Name + Image ───
                SizedBox(
                  width: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Impact',
                          fontSize: 26,
                          color: Color(0xFFBA4A22),
                          letterSpacing: 0.8,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Image without golden frame
                      Expanded(
                        child: Container(
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: data.isPlaceholder
                                ? Container(
                                    color: const Color(0xFFFDF6ED),
                                    child: const Center(
                                      child: Icon(
                                        Icons.pets,
                                        color: Color(0xFFBA4A22),
                                        size: 50,
                                      ),
                                    ),
                                  )
                                : Image.network(
                                    data.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.pets,
                                        color: Color(0xFFBA4A22),
                                        size: 40,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // ─── RIGHT: Owner info + details + status ───
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Owner row
                      Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Color(0xFFBA4A22),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 11,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data.ownerName,
                            style: const TextStyle(
                              color: Color(0xFFBA4A22),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            data.time,
                            style: const TextStyle(
                              color: Color(0xFFD3A482),
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Details: Adult | Cat | Angora | Lost
                      Text(
                        data.details,
                        style: const TextStyle(
                          color: Color(0xFFBA4A22),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFBA4A22),
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          'Current status: ${data.status}',
                          style: const TextStyle(
                            color: Color(0xFFBA4A22),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Description
                      Text(
                        '"${data.description}"',
                        style: const TextStyle(
                          color: Color(0xFFBA4A22),
                          fontSize: 10.5,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // === CONTACT BUTTON ===
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFBA4A22),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════ MAP SECTION ═══════════════════════════
  Widget _buildMapSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Map image
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFBA4A22), width: 1.5),
              bottom: BorderSide(color: Color(0xFFBA4A22), width: 1.5),
            ),
          ),
          child: Image.asset(
            'assets/images/Map/map.png',
            width: double.infinity,
            height: 190,
            fit: BoxFit.cover,
            color: Colors.white.withValues(alpha: 0.3),
            colorBlendMode: BlendMode.screen,
          ),
        ),
        // Left pin
        Positioned(left: 40, top: 30, child: _buildMapPin(Icons.pets)),
        // Right pin
        Positioned(right: 50, bottom: 45, child: _buildMapPin(Icons.add)),
        // VIEW ON MAP button
        Positioned(
          left: 0,
          right: 0,
          bottom: -16,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFBA4A22), width: 1.0),
              ),
              child: const Text(
                'VIEW ON THE MAP ITS LAST LOCATION',
                style: TextStyle(
                  color: Color(0xFFBA4A22),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Impact',
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapPin(IconData icon) {
    return SizedBox(
      width: 40,
      height: 50,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const Icon(Icons.location_on, color: Color(0xFFBA4A22), size: 48),
          Positioned(
            top: 6,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFBA4A22),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════ LATEST INFO ═══════════════════════════
  Widget _buildLatestInfoSection(WidgetRef ref) {
    final commentsAsync = ref.watch(commentsProvider(data.id));
    final currentUser = ref.watch(currentUserProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 34, 16, 16),
      child: Column(
        children: [
          // Title
          const Text(
            'LATEST INFO',
            style: TextStyle(
              fontFamily: 'Impact',
              fontSize: 26,
              color: Color(0xFFBA4A22),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),

          commentsAsync.when(
            data: (comments) {
              if (comments.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No comments yet. Be the first to help!',
                    style: TextStyle(color: Color(0xFFBA4A22), fontSize: 12),
                  ),
                );
              }
              return Column(
                children: comments
                    .map(
                      (comment) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _buildCommentItem(comment),
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
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Error loading comments: $error',
                style: const TextStyle(color: Colors.red, fontSize: 10),
              ),
            ),
          ),

          const SizedBox(height: 14),
          // Comment bar at bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFBA4A22),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Comment as ${currentUser?.firstName ?? "User"}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Text(
                    'GIF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.sentiment_satisfied_alt,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentModel comment) {
    final authorName =
        '${comment.author.firstName.toLowerCase()}_${comment.author.lastName.toLowerCase()}';
    final timeFormatted =
        '${DateFormat('h').format(comment.createdAt)} hours ago'; // Simplified timeago

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
                style: const TextStyle(
                  color: Color(0xFFBA4A22),
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                timeFormatted,
                style: const TextStyle(color: Color(0xFFD3A482), fontSize: 10),
              ),
              const SizedBox(width: 8),
              Text(
                '${comment.likes.length}',
                style: const TextStyle(
                  color: Color(0xFFBA4A22),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.favorite, color: Color(0xFFBA4A22), size: 11),
            ],
          ),
          const SizedBox(height: 10),
          // Comment text
          Text(
            '"${comment.content}"',
            style: const TextStyle(
              color: Color(0xFFBA4A22),
              fontSize: 11,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          // I like / Reply
          const Row(
            children: [
              Text(
                'I like',
                style: TextStyle(
                  color: Color(0xFFBA4A22),
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              SizedBox(width: 20),
              Text(
                'Reply',
                style: TextStyle(
                  color: Color(0xFFBA4A22),
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
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
                    child: _buildReplyItem(reply),
                  ),
                )
                .toList(),

          if (comment.replies.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 11,
                    backgroundColor: Color(0xFFBA4A22),
                    child: Icon(Icons.person, color: Colors.white, size: 13),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Reply...',
                      style: TextStyle(color: Color(0xFFD3A482), fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReplyItem(CommentModel reply) {
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
            child: Text(
              reply.content,
              style: const TextStyle(color: Color(0xFFBA4A22), fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════ GRID PAINTERS ═══════════════════════════
class GridBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFECDB)
      ..strokeWidth = 1.0;
    const double step = 60.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFECDB)
      ..strokeWidth = 1.0;
    const double step = 60.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
