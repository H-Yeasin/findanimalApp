import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../providers/report_form_provider.dart';
import '../widgets/report_base_layout.dart';

class ReportStep1Screen extends ConsumerStatefulWidget {
  const ReportStep1Screen({super.key});

  @override
  ConsumerState<ReportStep1Screen> createState() => _ReportStep1ScreenState();
}

class _ReportStep1ScreenState extends ConsumerState<ReportStep1Screen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  String? _selectedPostType;
  String? _selectedSpecies;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    final state = ref.read(reportFormProvider);
    _nameController.text = state.animalName ?? '';
    _breedController.text = state.breed ?? '';
    _selectedPostType = state.postType;
    _selectedSpecies = state.species;
    _selectedGender = state.gender;
  }

  @override
  Widget build(BuildContext context) {
    return ReportBaseLayout(
      currentStep: 1,
      stepTitle: 'WHAT TYPE OF\nANIMAL?',
      onButtonPressed: () {
        // Validation
        if (_selectedPostType == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a post type.')),
          );
          return;
        }
        if (_nameController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter your animal's name.")),
          );
          return;
        }
        if (_selectedSpecies == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select the species.')),
          );
          return;
        }
        if (_selectedGender == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select the gender.')),
          );
          return;
        }
        ref
            .read(reportFormProvider.notifier)
            .setBasicInfo(
              postType: _selectedPostType,
              animalName: _nameController.text,
              species: _selectedSpecies,
              breed: _breedController.text,
              gender: _selectedGender,
            );
        context.push(RouteNames.reportCreateStep2);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('WHAT TYPES OF ADS DO YOU WANT TO PUBLISH?'),
          _buildDropdown(
            value: _selectedPostType,
            hint: 'Post Types',
            items: ['Lost', 'Found', 'Spotted', 'Injured'],
            onChanged: (val) => setState(() => _selectedPostType = val),
          ),
          const SizedBox(height: 20),
          _buildLabel("WHAT IS YOUR ANIMAL'S NAME?"),
          _buildTextField(
            controller: _nameController,
            hint: "Enter my pet's name",
          ),
          const SizedBox(height: 20),
          _buildLabel('WHAT SPECIES IS IT?'),
          _buildDropdown(
            value: _selectedSpecies,
            hint: 'Species of the animal',
            items: ['Dog', 'Cat', 'Bird', 'Rabbit', 'Other'],
            onChanged: (val) => setState(() => _selectedSpecies = val),
          ),
          const SizedBox(height: 20),
          _buildLabel('WHAT RACE IS HE?'),
          _buildTextField(
            controller: _breedController,
            hint: 'Breed of the animal',
          ),
          const SizedBox(height: 20),
          _buildLabel('IS THIS A MALE OR FEMALE?'),
          Row(
            children: [
              _buildRadioButton('Male', _selectedGender == 'Male', () {
                setState(() => _selectedGender = 'Male');
              }),
              const SizedBox(width: 30),
              _buildRadioButton('Female', _selectedGender == 'Female', () {
                setState(() => _selectedGender = 'Female');
              }),
            ],
          ),
        ],
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9EAD4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBA4A22), width: 1),
      ),
      child: TextField(
        controller: controller,
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

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9EAD4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBA4A22), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(
              color: const Color(0xFFBA4A22).withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFBA4A22)),
          isExpanded: true,
          dropdownColor: const Color(0xFFF9EAD4),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(color: Color(0xFFBA4A22), fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildRadioButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFBA4A22), width: 1.5),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: Color(0xFFBA4A22),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFBA4A22),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
