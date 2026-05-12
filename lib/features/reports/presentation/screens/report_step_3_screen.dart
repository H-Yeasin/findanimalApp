import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../providers/report_form_provider.dart';
import '../widgets/report_base_layout.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

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
    final l10n = AppLocalizations.of(context);
    return ReportBaseLayout(
      currentStep: 3,
      stepTitle: l10n.reportStep3Title,
      onButtonPressed: () {
        // Validation
        if (_hasChip == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.reportStep3ChipRequired)));
          return;
        }
        if (_hasTattoo == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.reportStep3TattooRequired)),
          );
          return;
        }
        if (_hasCollar == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.reportStep3CollarRequired)),
          );
          return;
        }
        if (_eventDate == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.reportStep3DateRequired)));
          return;
        }
        ref.read(reportFormProvider.notifier).setTechnicalInfo(
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
          _buildQuestionSection(l10n.reportStep3ChipLabel, _hasChip, (val) {
            setState(() => _hasChip = val);
          }, l10n),
          const SizedBox(height: 25),
          _buildQuestionSection(l10n.reportStep3TattooLabel, _hasTattoo, (val) {
            setState(() => _hasTattoo = val);
          }, l10n),
          const SizedBox(height: 25),
          _buildQuestionSection(l10n.reportStep3CollarLabel, _hasCollar, (val) {
            setState(() => _hasCollar = val);
          }, l10n),
          const SizedBox(height: 25),
          _buildLabel(l10n.reportStep3DateLabel),
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
        style: AppTextStyles.body.copyWith(
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
    AppLocalizations l10n,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final optionWidth = ((constraints.maxWidth - 24) / 3).clamp(88.0, 160.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(question),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: optionWidth,
                  child: _buildRadioButton(
                    l10n.yes,
                    currentValue == 'Yes',
                    () => onChanged('Yes'),
                  ),
                ),
                SizedBox(
                  width: optionWidth,
                  child: _buildRadioButton(
                    l10n.no,
                    currentValue == 'No',
                    () => onChanged('No'),
                  ),
                ),
                SizedBox(
                  width: optionWidth,
                  child: _buildRadioButton(
                    l10n.dontKnow,
                    currentValue == 'Unknown',
                    () => onChanged('Unknown'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildRadioButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Expanded(
            child: Text(
              label,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                color: Color(0xFFBA4A22),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
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
              style: AppTextStyles.body.copyWith(
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
