import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../providers/community_providers.dart';
import '../screens/community_screen.dart';

mixin CommunityScreenMixin on ConsumerState<CommunityScreen> {
  final TextEditingController contentController = TextEditingController();
  final List<File> selectedMedia = [];
  final ImagePicker picker = ImagePicker();

  GoogleMapController? mapController;
  LatLng currentPosition = const LatLng(0, 0);

  Future<void> initializeLocation() async {
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
        currentPosition = LatLng(position.latitude, position.longitude);
      });

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentPosition, 13),
      );
    } catch (e) {
      debugPrint('Error initializing location: $e');
    }
  }

  Future<void> handleLocateMe() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;

      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
      });

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentPosition, 14),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context).couldNotGetLocation} $e',
          ),
        ),
      );
    }
  }

  bool isUnauthorizedError(Object err) {
    final message = err.toString().toLowerCase();
    return message.contains('401') || message.contains('unauthorized');
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedMedia.add(File(image.path));
      });
    }
  }

  Future<void> pickVideo() async {
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        selectedMedia.add(File(video.path));
      });
    }
  }

  Future<void> pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedMedia.add(File(result.files.single.path!));
      });
    }
  }

  void removeSelectedMedia(int index) {
    setState(() {
      selectedMedia.removeAt(index);
    });
  }

  Future<void> submitPost() async {
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

    if (contentController.text.trim().isEmpty && selectedMedia.isEmpty) {
      return;
    }

    final content =
        contentController.text.trim().isEmpty && selectedMedia.isNotEmpty
            ? '.'
            : contentController.text;

    try {
      await ref.read(communityActionProvider.notifier).createChat(
            content: content,
            media: selectedMedia.isEmpty ? null : selectedMedia,
          );
    } catch (e) {
      if (mounted) {
        final unauthorized = isUnauthorizedError(e);
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

    contentController.clear();
    setState(() {
      selectedMedia.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.postSharedSuccess)));
    }
  }

  Future<void> shareStory() async {
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
                final file = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (context.mounted) Navigator.pop(context, file);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text(l10n.video),
              onTap: () async {
                final file = await picker.pickVideo(
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
        final unauthorized = isUnauthorizedError(e);
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

  Future<void> refreshCommunity() async {
    await initializeLocation();
    ref.invalidate(localStoriesProvider);
    ref.invalidate(localChatProvider);
    ref.invalidate(homeReportsProvider);
  }

  Set<Marker> buildReportMarkers() {
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

  void disposeLogic() {
    contentController.dispose();
    mapController?.dispose();
  }
}
