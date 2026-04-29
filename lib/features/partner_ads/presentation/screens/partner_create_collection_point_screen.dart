import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/widgets/app_top_bar.dart';
import '../widgets/partner_ui_kit.dart';
import '../../data/repositories/partner_ads_repository_impl.dart';

class PartnerCreateCollectionPointScreen extends ConsumerStatefulWidget {
  const PartnerCreateCollectionPointScreen({super.key});

  @override
  ConsumerState<PartnerCreateCollectionPointScreen> createState() =>
      _PartnerCreateCollectionPointScreenState();
}

class _PartnerCreateCollectionPointScreenState
    extends ConsumerState<PartnerCreateCollectionPointScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  double? _latitude;
  double? _longitude;
  XFile? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _pickLocation() async {
    // For now, I'll use a placeholder way to set location or navigate to a picker
    // Since the existing LocationPickerScreen is tied to reports, I'll suggest
    // a simplified manual entry or a generic picker if I had time to refactor.
    // However, I will implement a navigation to the location picker and handle it.

    // For this task, I'll simulate setting it or use a simple dialog for lat/lng
    // but the user wants "map manual location picking".
    // I'll create a simple navigation that returns LatLng.

    final result = await context.push<Map<String, dynamic>>(
      '/partner/location-picker',
    );
    if (result != null) {
      setState(() {
        _addressController.text = result['address'] ?? '';
        _latitude = result['lat'];
        _longitude = result['lng'];
      });
    }
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _latitude == null ||
        _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select location'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      MultipartFile? imageFile;
      if (_selectedImage != null) {
        imageFile = await MultipartFile.fromFile(_selectedImage!.path);
      }

      await ref
          .read(partnerAdsRepositoryProvider)
          .createCollectionPoint(
            title: _titleController.text,
            description: _descriptionController.text,
            address: _addressController.text,
            latitude: _latitude!,
            longitude: _longitude!,
            image: imageFile,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Collection point created successfully'),
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PartnerScreenScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppTopBar(showBackButton: false),
            const SizedBox(height: 6),
            const PartnerPageTitle('CREATE\nCOLLECTION POINT'),
            const SizedBox(height: 20),
            const PartnerSectionHeading(
              'POST AN ADVERTISEMENT - COLLECTION POINT',
              trailing: Icon(
                Icons.location_on_rounded,
                color: PartnerUiColors.brand,
                size: 28,
              ),
            ),
            const SizedBox(height: 20),
            const PartnerFieldLabel('COLLECTION POINT NAME'),
            const SizedBox(height: 10),
            PartnerInputField(
              controller: _titleController,
              hint: 'Collection point name',
            ),
            const SizedBox(height: 14),
            const PartnerFieldLabel('DESCRIPTION OF THE COLLECTION POINT'),
            const SizedBox(height: 10),
            PartnerInputField(
              controller: _descriptionController,
              hint: 'Description of the collection point',
              maxLines: 4,
            ),
            const SizedBox(height: 14),
            const PartnerFieldLabel('COLLECTION POINT ADDRESS'),
            const SizedBox(height: 10),
            InkWell(
              onTap: _pickLocation,
              child: PartnerOutlinedField(
                hint: _addressController.text.isEmpty
                    ? 'Pick location on map'
                    : _addressController.text,
                trailing: const Icon(
                  Icons.map_outlined,
                  color: PartnerUiColors.brand,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const PartnerFieldLabel('PHOTO OF COLLECTION POINT'),
            const SizedBox(height: 10),
            InkWell(
              onTap: _pickImage,
              child: PartnerOutlinedField(
                hint: _selectedImage == null
                    ? 'Upload a photo'
                    : 'Image selected',
                trailing: const Icon(
                  Icons.cloud_upload_outlined,
                  color: PartnerUiColors.brand,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: PartnerUiColors.brand,
                    )
                  : PartnerPublishButton(
                      label: 'CREATE COLLECTION POINT',
                      onTap: _submit,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
