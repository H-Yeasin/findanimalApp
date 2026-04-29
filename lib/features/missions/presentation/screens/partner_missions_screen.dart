import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/widgets/app_top_bar.dart';
import '../../../partner_ads/presentation/widgets/partner_ui_kit.dart';
import '../../data/models/mission_model.dart';
import '../../data/repositories/missions_repository_impl.dart';
import '../providers/partner_missions_provider.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields with valid values.'),
        ),
      );
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Local mission created successfully.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not create mission: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final missionsAsync = ref.watch(partnerMissionsProvider);

    return PartnerScreenScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppTopBar(showBackButton: false),
            const SizedBox(height: 14),
            const PartnerPageTitle('MY\nLOCAL MISSIONS'),
            const SizedBox(height: 16),
            _buildCreateCard(),
            const SizedBox(height: 16),
            const PartnerSectionHeading('MY CREATED MISSIONS'),
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
                    const Text(
                      'Could not load your missions.',
                      style: TextStyle(
                        color: PartnerUiColors.brand,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () => ref.invalidate(partnerMissionsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (missions) {
                if (missions.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'No missions created yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: PartnerUiColors.brand,
                        fontFamily: 'Impact',
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

  Widget _buildCreateCard() {
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
          const PartnerFieldLabel('MISSION TITLE'),
          const SizedBox(height: 8),
          PartnerInputField(
            controller: _titleController,
            hint: 'Title of local mission',
          ),
          const SizedBox(height: 10),
          const PartnerFieldLabel('DESCRIPTION'),
          const SizedBox(height: 8),
          PartnerInputField(
            controller: _descriptionController,
            hint: 'Mission description',
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          const PartnerFieldLabel('ADDRESS'),
          const SizedBox(height: 8),
          PartnerInputField(
            controller: _addressController,
            hint: 'Address of local mission',
          ),
          const SizedBox(height: 10),
          const PartnerFieldLabel('DURATION'),
          const SizedBox(height: 8),
          PartnerInputField(
            controller: _durationController,
            hint: 'Duration of local mission',
          ),
          const SizedBox(height: 10),
          const PartnerFieldLabel('POINTS'),
          const SizedBox(height: 8),
          PartnerInputField(controller: _pointsController, hint: 'e.g. 250'),
          const SizedBox(height: 10),
          const PartnerFieldLabel('MISSION IMAGE (OPTIONAL)'),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickImage,
            child: PartnerOutlinedField(
              hint: _selectedImage == null
                  ? 'Upload mission image'
                  : 'Image selected',
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
                    label: 'CREATE LOCAL MISSION',
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
                    fontFamily: 'Impact',
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
                  'Duration: ${mission.duration} | Points: ${mission.points ?? 0}',
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
