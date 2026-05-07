import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

const makeDonationBackgroundColor = Color(0xFFFDF8F2);
const makeDonationPrimaryOrange = Color(0xFFBA4A22);

final makeDonationHeaderStyle = AppTextStyles.body.copyWith(
  fontFamily: 'Erica One',
  color: Color(0xFFFBF1D7),
  fontSize: 40,
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
  shadows: [Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 4)],
);
