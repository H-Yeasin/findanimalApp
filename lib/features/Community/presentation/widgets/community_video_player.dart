import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/localization/app_localizations.dart';

final activeVideoProvider = StateProvider<String?>((ref) => null);

class VideoPlayerWidget extends ConsumerStatefulWidget {
  const VideoPlayerWidget({super.key, required this.url});

  final String url;

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  Future<void> _initializePlayer() async {
    if (_isInitialized) return;

    final cleanUrl = widget.url.trim();
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(cleanUrl));
      await _controller!.initialize();
      if (!mounted) return;

      setState(() {
        _isInitialized = true;
        _hasError = false;
      });
      _controller!.play();
    } catch (e) {
      debugPrint('Video Error for $cleanUrl: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
            Text(
              l10n.videoLoadFailed,
              style: TextStyle(color: Color(0xFFBA4A22), fontSize: 12),
            ),
            TextButton(
              onPressed: _initializePlayer,
              child: Text(
                l10n.retry,
                style: const TextStyle(color: Color(0xFFBA4A22)),
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
        child: InkWell(
          onTap: _initializePlayer,
          child: const Center(
            child: Icon(
              Icons.play_circle_fill,
              color: Color(0xFFBA4A22),
              size: 50,
            ),
          ),
        ),
      );
    }

    final activeVideoUrl = ref.watch(activeVideoProvider);
    if (activeVideoUrl != widget.url && _controller!.value.isPlaying) {
      _controller!.pause();
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller!.value.isPlaying) {
            _controller!.pause();
            ref.read(activeVideoProvider.notifier).state = null;
          } else {
            ref.read(activeVideoProvider.notifier).state = widget.url;
            _controller!.play();
          }
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
          if (!_controller!.value.isPlaying)
            const Icon(Icons.play_circle_fill, color: Colors.white70, size: 50),
          Positioned(
            bottom: 5,
            right: 5,
            child: Icon(
              _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
