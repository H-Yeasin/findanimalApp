import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/widgets/app_top_bar.dart';
import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';
import '../../data/models/mission_model.dart';
import '../../data/repositories/missions_repository_impl.dart';
import '../providers/partner_missions_provider.dart';
import '../../../../core/localization/app_localizations.dart';

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

  Future<void> _createMission() async {
    final points = int.tryParse(_pointsController.text.trim());

    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _durationController.text.trim().isEmpty ||
        points == null ||
        points <= 0) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.fillAllFields)));
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
      setState(() => _selectedImage = null);

      ref.invalidate(partnerMissionsProvider);

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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppTopBar(showBackButton: false),
            const SizedBox(height: 14),
            PartnerPageTitle(l10n.myLocalMissions),
            const SizedBox(height: 16),
            _buildCreateCard(l10n),
            const SizedBox(height: 16),
            PartnerSectionHeading(l10n.myCreatedMissions),
            const SizedBox(height: 10),
            missionsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Center(
                  child: CircularProgressIndicator(
                    color: PartnerUiColors.brand,
                  ),
                ),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Text(
                      l10n.couldNotLoadMissions,
                      style: const TextStyle(
                        color: PartnerUiColors.brand,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () => ref.invalidate(partnerMissionsProvider),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
              data: (missions) {
                if (missions.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      l10n.noMissionsCreated,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: PartnerUiColors.brand,
                        fontFamily: 'EricaOne',
                        fontSize: 22,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: missions.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _MissionItemCard(mission: missions[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PartnerUiColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PartnerUiColors.brand),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PartnerFieldLabel(l10n.missionTitle),
          const SizedBox(height: 8),
          PartnerInputField(
            controller: _titleController,
            hint: l10n.missionTitleHint,
          ),
          const SizedBox(height: 10),
          PartnerFieldLabel(l10n.message.toUpperCase()),
          const SizedBox(height: 8),
          PartnerInputField(
            controller: _descriptionController,
            hint: l10n.missionDescriptionHint,
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          PartnerFieldLabel(l10n.fieldAddress.toUpperCase()),
          const SizedBox(height: 8),
          PartnerInputField(
            controller: _addressController,
            hint: l10n.missionAddressHint,
          ),
          const SizedBox(height: 10),
          PartnerFieldLabel(
            l10n.categoryMessaging.toUpperCase(),
          ), // Or use a proper duration label if available
          const SizedBox(height: 8),
          PartnerInputField(
            controller: _durationController,
            hint: l10n.missionDurationHint,
          ),
          const SizedBox(height: 10),
          PartnerFieldLabel(l10n.myPoints.toUpperCase()),
          const SizedBox(height: 8),
          PartnerInputField(controller: _pointsController, hint: 'e.g. 250'),
          const SizedBox(height: 10),
          PartnerFieldLabel(l10n.missionImageOptional),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickImage,
            child: PartnerOutlinedField(
              _selectedImage == null
                  ? l10n.uploadMissionImage
                  : l10n.imageSelected,
              trailing: const Icon(
                Icons.cloud_upload_outlined,
                color: PartnerUiColors.brand,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: _isSubmitting
                ? const CircularProgressIndicator(color: PartnerUiColors.brand)
                : PartnerPublishButton(
                    label: l10n.createLocalMission,
                    onTap: _createMission,
                  ),
          ),
        ],
      ),
    );
  }
}

class _MissionItemCard extends StatelessWidget {
  const _MissionItemCard({required this.mission});

  final MissionModel mission;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PartnerUiColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PartnerUiColors.brand),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: mission.photo != null
                ? Image.network(
                    mission.photo!.secureUrl,
                    width: 74,
                    height: 74,
                    fit: BoxFit.cover,
                    errorBuilder: (_, error, stackTrace) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.title,
                  style: const TextStyle(
                    color: PartnerUiColors.brand,
                    fontFamily: 'EricaOne',
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mission.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: PartnerUiColors.brand,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  l10n.durationPoints
                      .replaceAll('{duration}', mission.duration)
                      .replaceAll('{points}', (mission.points ?? 0).toString()),
                  style: const TextStyle(
                    color: PartnerUiColors.brand,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 74,
      height: 74,
      color: const Color(0xFFE4D5B6),
      child: const Icon(Icons.flag_outlined, color: PartnerUiColors.brand),
    );
  }
}
