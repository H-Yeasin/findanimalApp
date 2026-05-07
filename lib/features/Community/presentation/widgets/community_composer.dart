import 'dart:io';

import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';

class CommunityComposer extends StatelessWidget {
  const CommunityComposer({
    super.key,
    required this.contentController,
    required this.selectedMedia,
    required this.onPickImage,
    required this.onPickVideo,
    required this.onPickFile,
    required this.onRemoveMedia,
    required this.onSubmitPost,
    required this.pictureLabel,
    required this.videoLabel,
    required this.fileLabel,
    required this.mindHint,
  });

  final TextEditingController contentController;
  final List<File> selectedMedia;
  final VoidCallback onPickImage;
  final VoidCallback onPickVideo;
  final VoidCallback onPickFile;
  final ValueChanged<int> onRemoveMedia;
  final VoidCallback onSubmitPost;
  final String pictureLabel;
  final String videoLabel;
  final String fileLabel;
  final String mindHint;

  static const _brandPrimary = Color(0xFFBA4A22);
  static const _boxBg = Color(0xFFFFF6E5);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _boxBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _brandPrimary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(AppAssets.accountIcon),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                      hintText: mindHint,
                      hintStyle: TextStyle(
                        color: _brandPrimary.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: _brandPrimary, fontSize: 14),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: _brandPrimary),
                onPressed: onSubmitPost,
              ),
            ],
          ),
          if (selectedMedia.isNotEmpty)
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedMedia.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8, top: 8),
                        child: _MediaPreview(file: selectedMedia[index]),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () => onRemoveMedia(index),
                          child: const CircleAvatar(
                            radius: 8,
                            backgroundColor: _brandPrimary,
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
              _ActionItem(
                icon: Icons.image,
                label: pictureLabel,
                onTap: onPickImage,
              ),
              _ActionItem(
                icon: Icons.videocam,
                label: videoLabel,
                onTap: onPickVideo,
              ),
              _ActionItem(
                icon: Icons.folder,
                label: fileLabel,
                onTap: onPickFile,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MediaPreview extends StatelessWidget {
  const _MediaPreview({required this.file});

  final File file;

  bool get _isVideo {
    final path = file.path.toLowerCase();
    return path.endsWith('.mp4') || path.endsWith('.mov');
  }

  @override
  Widget build(BuildContext context) {
    if (_isVideo) {
      return Container(
        width: 50,
        height: 50,
        color: CommunityComposer._brandPrimary.withValues(alpha: 0.1),
        child: const Icon(Icons.videocam, color: CommunityComposer._brandPrimary),
      );
    }

    return Image.file(file, width: 50, height: 50, fit: BoxFit.cover);
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: CommunityComposer._brandPrimary, size: 28),
          Text(
            label,
            style: const TextStyle(
              color: CommunityComposer._brandPrimary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
