import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class SeekStatusFilterOption {
  const SeekStatusFilterOption(this.value, this.label);

  final String value;
  final String label;
}

class SeekFilterPanel extends StatelessWidget {
  const SeekFilterPanel({required this.child, this.topPadding = 0, super.key});

  final Widget child;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF2E6D8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class SeekRadioOptionRow<T> extends StatelessWidget {
  const SeekRadioOptionRow({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
    super.key,
  });

  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 34,
        child: Row(
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: (next) {
                if (next != null) onChanged(next);
              },
              activeColor: const Color(0xFFBA4A22),
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: Color(0xFFBA4A22),
                  fontSize: 15,
                  fontFamily: 'EricaOne',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeekFilterOptionRow extends StatelessWidget {
  const SeekFilterOptionRow({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 28,
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFBA4A22) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFBA4A22), width: 1.5),
              ),
              child: Icon(
                isSelected ? Icons.check_rounded : Icons.close_rounded,
                color: isSelected ? Colors.white : const Color(0xFFBA4A22),
                size: 13,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: Color(0xFFBA4A22),
                  fontSize: 12,
                  fontFamily: 'EricaOne',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
