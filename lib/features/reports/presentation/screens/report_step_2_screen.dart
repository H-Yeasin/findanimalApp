import 'dart:io';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../providers/report_form_provider.dart';
import '../widgets/report_base_layout.dart';

class ReportStep2Screen extends ConsumerStatefulWidget {
  const ReportStep2Screen({super.key});

  @override
  ConsumerState<ReportStep2Screen> createState() => _ReportStep2ScreenState();
}

class _ReportStep2ScreenState extends ConsumerState<ReportStep2Screen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<File> _pickedImages = [];

  @override
  void initState() {
    super.initState();
    final state = ref.read(reportFormProvider);
    _addressController.text = state.address ?? '';
    _descriptionController.text = state.description ?? '';
    _pickedImages = List.from(state.images);
  }

  Future<void> _pickImage() async {
    final l10n = AppLocalizations.of(context);
    if (_pickedImages.length >= 3) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.reportStep2MaxPhotos)));
      return;
    }

    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImages.add(File(image.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Listen for address changes from the map picker
    ref.listen(reportFormProvider.select((s) => s.address), (prev, next) {
      if (next != null && next != _addressController.text) {
        _addressController.text = next;
      }
    });

    return ReportBaseLayout(
      currentStep: 2,
      stepTitle: l10n.reportStep2Title,
      onButtonPressed: () {
        // Validation
        if (_addressController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.reportStep2LocationRequired)),
          );
          return;
        }
        if (_descriptionController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.reportStep2DescriptionRequired)),
          );
          return;
        }
        ref
            .read(reportFormProvider.notifier)
            .setDescriptionInfo(
              address: _addressController.text,
              description: _descriptionController.text,
              images: _pickedImages,
            );
        context.push(RouteNames.reportCreateStep3);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(l10n.reportStep2LocationLabel),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _addressController,
                  hint: l10n.reportStep2LocationHint,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => context.push(RouteNames.reportLocationPicker),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBA4A22),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.map, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          _buildLabel(l10n.reportStep2DescriptionLabel),
          _buildTextField(
            controller: _descriptionController,
            hint: l10n.reportStep2DescriptionHint,
            maxLines: 5,
          ),
          const SizedBox(height: 25),
          _buildLabel(l10n.reportStep2PhotosLabel),
          if (_pickedImages.isNotEmpty) ...[
            _buildImageList(),
            const SizedBox(height: 15),
          ],
          _buildUploadBox(l10n),
        ],
      ),
    );
  }

  Widget _buildImageList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _pickedImages.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFBA4A22), width: 1),
                  image: DecorationImage(
                    image: FileImage(_pickedImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 20,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFBA4A22),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFFBA4A22),
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9EAD4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBA4A22), width: 1),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Color(0xFFBA4A22), fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: const Color(0xFFBA4A22).withValues(alpha: 0.5),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildUploadBox(AppLocalizations l10n) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF9EAD4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFBA4A22), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFBA4A22),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_upload,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              l10n.reportStep2UploadHint,
              style: TextStyle(
                color: const Color(0xFFBA4A22).withValues(alpha: 0.6),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
