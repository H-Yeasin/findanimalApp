import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../providers/report_form_provider.dart';
import '../widgets/report_base_layout.dart';

class ReportStep4Screen extends ConsumerStatefulWidget {
  const ReportStep4Screen({super.key});

  @override
  ConsumerState<ReportStep4Screen> createState() => _ReportStep4ScreenState();
}

class _ReportStep4ScreenState extends ConsumerState<ReportStep4Screen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isPhoneVisible = false;
  bool _isEmailVisible = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(reportFormProvider);
    _phoneController.text = state.phoneNumber ?? '';
    _emailController.text = state.emailAddress ?? '';
    _isPhoneVisible = state.isPhoneVisible;
    _isEmailVisible = state.isEmailVisible;
  }

  @override
  Widget build(BuildContext context) {
    return ReportBaseLayout(
      currentStep: 4,
      stepTitle: 'PERSONAL\nINFORMATION',
      buttonText: ref
          .watch(reportFormProvider)
          .submissionState
          .maybeWhen(
            loading: () => 'Publishing...',
            orElse: () => 'Publish my ad',
          ),
      onButtonPressed: () async {
        // Validation — at least one contact method required
        final phone = _phoneController.text.trim();
        final email = _emailController.text.trim();
        if (phone.isEmpty && email.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please provide at least a phone number or email address.',
              ),
            ),
          );
          return;
        }
        if (email.isNotEmpty &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter a valid email address.'),
            ),
          );
          return;
        }
        ref
            .read(reportFormProvider.notifier)
            .setPersonalInfo(
              phoneNumber: _phoneController.text,
              isPhoneVisible: _isPhoneVisible,
              emailAddress: _emailController.text,
              isEmailVisible: _isEmailVisible,
            );

        final success = await ref.read(reportFormProvider.notifier).submit();

        if (success) {
          if (mounted) {
            ref.read(reportFormProvider.notifier).reset();
            // ignore: use_build_context_synchronously
            context.go(RouteNames.root);

            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Report published successfully!'),
                backgroundColor: Color(0xFFBA4A22),
              ),
            );
          }
        } else {
          if (mounted) {
            final error = ref.read(reportFormProvider).submissionState.error;
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error publishing report: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('YOUR PHONE NUMBER'),
          _buildTextField(
            controller: _phoneController,
            hint: 'My phone number',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 10),
          _buildCheckbox('Make it visible on my report', _isPhoneVisible, (
            val,
          ) {
            setState(() => _isPhoneVisible = val);
          }),
          const SizedBox(height: 25),
          _buildLabel('YOUR EMAIL ADDRESS'),
          _buildTextField(
            controller: _emailController,
            hint: 'My email address',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          _buildCheckbox('Make it visible on my report', _isEmailVisible, (
            val,
          ) {
            setState(() => _isEmailVisible = val);
          }),
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9EAD4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBA4A22), width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
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

  Widget _buildCheckbox(
    String label,
    bool isChecked,
    Function(bool) onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFBA4A22), width: 1.5),
            ),
            child: isChecked
                ? const Icon(Icons.check, color: Color(0xFFBA4A22), size: 18)
                : null,
          ),
          const SizedBox(width: 12),
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
