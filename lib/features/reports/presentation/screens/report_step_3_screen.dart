import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../providers/report_form_provider.dart';
import '../widgets/report_base_layout.dart';

class ReportStep3Screen extends ConsumerStatefulWidget {
  const ReportStep3Screen({super.key});

  @override
  ConsumerState<ReportStep3Screen> createState() => _ReportStep3ScreenState();
}

class _ReportStep3ScreenState extends ConsumerState<ReportStep3Screen> {
  String? _hasChip;
  String? _hasTattoo;
  String? _hasCollar;
  DateTime? _eventDate;

  @override
  void initState() {
    super.initState();
    final state = ref.read(reportFormProvider);
    _hasChip = state.hasMicrochip;
    _hasTattoo = state.hasTattoo;
    _hasCollar = state.hasCollarOrHarness;
    _eventDate = state.eventDate;
  }

  @override
  Widget build(BuildContext context) {
    return ReportBaseLayout(
      currentStep: 3,
      stepTitle: 'TECHNICAL\nINFORMATION',
      onButtonPressed: () {
        ref
            .read(reportFormProvider.notifier)
            .setTechnicalInfo(
              hasMicrochip: _hasChip,
              hasTattoo: _hasTattoo,
              hasCollarOrHarness: _hasCollar,
              eventDate: _eventDate,
            );
        context.push(RouteNames.reportCreateStep4);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionSection('DOES IT HAVE AN ELECTRONIC CHIP?', _hasChip, (
            val,
          ) {
            setState(() => _hasChip = val);
          }),
          const SizedBox(height: 25),
          _buildQuestionSection('DOES HE HAVE A TATTOO?', _hasTattoo, (val) {
            setState(() => _hasTattoo = val);
          }),
          const SizedBox(height: 25),
          _buildQuestionSection(
            'DOES HE HAVE A COLLAR OR HARNESS?',
            _hasCollar,
            (val) {
              setState(() => _hasCollar = val);
            },
          ),
          const SizedBox(height: 25),
          _buildLabel('WHEN DID THIS HAPPEN?'),
          _buildDatePicker(),
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

  Widget _buildQuestionSection(
    String question,
    String? currentValue,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(question),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRadioButton(
              'Yes',
              currentValue == 'Yes',
              () => onChanged('Yes'),
            ),
            _buildRadioButton(
              'No',
              currentValue == 'No',
              () => onChanged('No'),
            ),
            _buildRadioButton(
              "I don't know",
              currentValue == "I don't know",
              () => onChanged("I don't know"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFBA4A22), width: 1.5),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFFBA4A22),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFBA4A22),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    String dateText = 'DD/MM/YYYY';
    if (_eventDate != null) {
      dateText = '${_eventDate!.day}/${_eventDate!.month}/${_eventDate!.year}';
    }

    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFFBA4A22),
                  onPrimary: Colors.white,
                  onSurface: Color(0xFFBA4A22),
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          setState(() => _eventDate = date);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFF9EAD4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFBA4A22), width: 1),
        ),
        child: Row(
          children: [
            Text(
              dateText,
              style: TextStyle(
                color: const Color(0xFFBA4A22).withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
