import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/routing/route_names.dart';
import '../../core/widgets/app_top_bar.dart';
import '../auth/presentation/providers/auth_provider.dart';
import '../home/presentation/providers/home_providers.dart';
import 'presentation/providers/community_providers.dart';
import 'presentation/widgets/community_bottom_sections.dart';
import 'presentation/widgets/community_header_section.dart';
import 'presentation/widgets/community_post_list.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final TextEditingController _contentController = TextEditingController();
  final List<File> _selectedMedia = [];
  final ImagePicker _picker = ImagePicker();

  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 13),
      );
    } catch (e) {
      debugPrint('Error initializing location: $e');
    }
  }

  Future<void> _handleLocateMe() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 14),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context).couldNotGetLocation} $e')));
    }
  }

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

  void _removeSelectedMedia(int index) {
    setState(() {
      _selectedMedia.removeAt(index);
    });
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

    final content =
        _contentController.text.trim().isEmpty && _selectedMedia.isNotEmpty
        ? '.'
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

    if (media == null || !mounted) return;

    final String? caption = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(
            l10n.newStory,
            style: const TextStyle(fontFamily: 'EricaOne'),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: l10n.addCaptionHint),
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

    if (caption == null) return;

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

    ref.invalidate(localStoriesProvider);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.storySharedSuccess)));
    }
  }

  Future<void> _refreshCommunity() async {
    await _initializeLocation();
    ref.invalidate(localStoriesProvider);
    ref.invalidate(localChatProvider);
    ref.invalidate(homeReportsProvider);
  }

  Set<Marker> _buildReportMarkers() {
    final reportsAsync = ref.watch(homeReportsProvider);
    final reports = reportsAsync.valueOrNull;
    if (reports == null) return {};

    return {
      for (final report in reports)
        if (report.location.coordinates.length >= 2)
          Marker(
            markerId: MarkerId('comm_${report.id}'),
            position: LatLng(
              report.location.coordinates[1],
              report.location.coordinates[0],
            ),
            infoWindow: InfoWindow(
              title: report.animalName.toUpperCase(),
              snippet: '${report.status} | ${report.breed}',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              report.status.toLowerCase() == 'found'
                  ? BitmapDescriptor.hueAzure
                  : BitmapDescriptor.hueOrange,
            ),
          ),
    };
  }

  void _showReactions(BuildContext context, String chatId) {
    final emojis = [
      '\u{1F44D}',
      '\u2764\uFE0F',
      '\u{1F602}',
      '\u{1F62E}',
      '\u{1F622}',
      '\u{1F621}',
    ];

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

  @override
  void dispose() {
    _contentController.dispose();
    _mapController?.dispose();
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
      body: RefreshIndicator(
        onRefresh: _refreshCommunity,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: AppTopBar(
                  showBackButton: false,
                  leftWidget: IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      color: brandPrimary,
                      shadows: [
                        BoxShadow(
                          color: brandPrimary.withValues(alpha: 0.25),
                          offset: const Offset(0, 4),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                      size: 30,
                    ),
                    onPressed: () => context.push(RouteNames.mainNotifications),
                  ),
                  userImageUrl: profileImage,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CommunityHeaderSection(
                contentController: _contentController,
                selectedMedia: _selectedMedia,
                storiesAsync: storiesAsync,
                isUnauthorizedError: _isUnauthorizedError,
                onPickImage: _pickImage,
                onPickVideo: _pickVideo,
                onPickFile: _pickFile,
                onRemoveMedia: _removeSelectedMedia,
                onSubmitPost: _submitPost,
                onShareStory: _shareStory,
              ),
            ),
            CommunityPostList(
              chatsAsync: chatAsync,
              isUnauthorizedError: _isUnauthorizedError,
              onShowReactions: _showReactions,
              onToggleLike: (chatId) {
                ref.read(communityActionProvider.notifier).toggleLike(chatId);
              },
            ),
            SliverToBoxAdapter(
              child: CommunityBottomSections(
                currentPosition: _currentPosition,
                markers: _buildReportMarkers(),
                hasReportsError: reportsAsync.hasError,
                onMapCreated: (controller) => _mapController = controller,
                onCameraMove: (position) {
                  _currentPosition = position.target;
                },
                onLocateMe: _handleLocateMe,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
