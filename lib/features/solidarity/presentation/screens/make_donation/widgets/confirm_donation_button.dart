import 'package:flutter/material.dart';

class ConfirmDonationButton extends StatelessWidget {
  const ConfirmDonationButton({
    super.key,
    required this.primaryOrange,
    required this.onTap,
  });

  final Color primaryOrange;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF8F2),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: primaryOrange, width: 1.5),
          ),
          child: Text(
            'CONFIRM MY\nDONATION',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primaryOrange,
              fontFamily: 'EricaOne',
              fontSize: 16,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
