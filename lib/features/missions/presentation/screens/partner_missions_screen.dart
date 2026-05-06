import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/app_top_bar.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import '../../data/repositories/missions_repository_impl.dart';
import '../providers/missions_list_provider.dart';
import '../providers/partner_missions_provider.dart';
import '../widgets/partner_created_missions_list.dart';
import '../widgets/partner_mission_create_card.dart';

class PartnerMissionsScreen extends ConsumerStatefulWidget {
  const PartnerMissionsScreen({super.key});

  @override
  ConsumerState<PartnerMissionsScreen> createState() =>
      _PartnerMissionsScreenState();
}

class _PartnerMissionsScreenState extends ConsumerState<PartnerMissionsScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _durationController = TextEditingController();
  final _pointsController = TextEditingController();

  double? _latitude;
  double? _longitude;
  XFile? _selectedImage;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _durationController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _pickLocation() async {
    final result = await context.push<Map<String, dynamic>>(
      '/partner/location-picker',
    );
    if (result == null || !mounted) return;

    final lat = (result['lat'] as num?)?.toDouble();
    final lng = (result['lng'] as num?)?.toDouble();
    if (lat == null || lng == null) return;

    setState(() {
      _addressController.text = (result['address'] ?? '').toString();
      _latitude = lat;
      _longitude = lng;
    });
  }

  Future<void> _createMission() async {
    final points = int.tryParse(_pointsController.text.trim());
    final l10n = AppLocalizations.of(context);

    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _latitude == null ||
        _longitude == null ||
        _durationController.text.trim().isEmpty ||
        points == null ||
        points <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.fillAllFieldsAndLocation)));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      MultipartFile? imageFile;
      if (_selectedImage != null) {
        imageFile = await MultipartFile.fromFile(_selectedImage!.path);
      }

      await ref
          .read(missionsRepositoryProvider)
          .createLocalMission(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            address: _addressController.text.trim(),
            latitude: _latitude!,
            longitude: _longitude!,
            duration: _durationController.text.trim(),
            points: points,
            image: imageFile,
          );

      if (!mounted) return;

      _titleController.clear();
      _descriptionController.clear();
      _addressController.clear();
      _durationController.clear();
      _pointsController.clear();
      setState(() {
        _selectedImage = null;
        _latitude = null;
        _longitude = null;
      });

      ref.invalidate(partnerMissionsProvider);
      ref.invalidate(missionsListProvider);

      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.missionCreated)));
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.couldNotCreateMission.replaceAll('{error}', e.toString()),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final missionsAsync = ref.watch(partnerMissionsProvider);

    return PartnerScreenScaffold(
      bottomNavIndex: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppTopBar(showUserAvatar: false),
            const SizedBox(height: 14),
            PartnerPageTitle(l10n.myLocalMissions),
            const SizedBox(height: 16),
            PartnerMissionCreateCard(
              titleController: _titleController,
              descriptionController: _descriptionController,
              addressController: _addressController,
              durationController: _durationController,
              pointsController: _pointsController,
              latitude: _latitude,
              longitude: _longitude,
              hasSelectedImage: _selectedImage != null,
              isSubmitting: _isSubmitting,
              onPickLocation: _pickLocation,
              onPickImage: _pickImage,
              onCreateMission: _createMission,
            ),
            const SizedBox(height: 16),
            PartnerSectionHeading(l10n.myCreatedMissions),
            const SizedBox(height: 10),
            PartnerCreatedMissionsList(missionsAsync: missionsAsync),
          ],
        ),
      ),
    );
  }
}
