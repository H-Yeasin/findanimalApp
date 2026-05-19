import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../home/presentation/widgets/custom_bottom_navigation_bar.dart';

class PartnerUiColors {
  const PartnerUiColors._();

  static const Color brand = Color(0xFFBA4A22);
  static const Color background = Color(0xFFEDEDED);
  static const Color panel = Color(0xFFFBF1D7);
  static const Color grid = Color(0xFFE7DCCB);
  static const Color lightText = Color(0xFFF8F0DC);
}

class PartnerScreenScaffold extends StatelessWidget {
  const PartnerScreenScaffold({
    required this.child,
    this.header,
    this.bottomNavIndex = 2,
    this.scrollController,
    super.key,
  });

  final Widget child;
  final Widget? header;
  final int bottomNavIndex;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            ?header,
            Expanded(
              child: SafeArea(
                top: false,
                bottom: false,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: child,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: bottomNavIndex,
          onTap: (_) => context.go(RouteNames.root),
        ),
      ),
    );
  }
}

class PartnerHeroHeader extends StatelessWidget {
  const PartnerHeroHeader({
    required this.title,
    required this.imageUrl,
    this.height = 250,
    super.key,
  });

  final String title;
  final String imageUrl;
  final double height;

  bool get _isNetworkImage =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  Widget _buildImage() {
    final fallback = Image.asset(AppAssets.homeHero, fit: BoxFit.cover);

    if (imageUrl.isEmpty) return fallback;

    if (_isNetworkImage) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : fallback,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }

    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Colors.black),
          _buildImage(),
          Container(color: Colors.black.withValues(alpha: 0.28)),
          Positioned(left: 22, top: 38, child: const PartnerBackButton()),
          Align(
            alignment: const Alignment(0, 0.08),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading.copyWith(
                  color: PartnerUiColors.lightText,
                  fontSize: 56 / 2,
                  height: 1.05,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PartnerBackButton extends StatelessWidget {
  const PartnerBackButton({this.onPressed, super.key});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onPressed ??
          () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteNames.root);
            }
          },
      customBorder: const CircleBorder(),
      child: Container(
        width: 43,
        height: 43,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: PartnerUiColors.brand,
        ),
        child: const Icon(Icons.undo, color: Colors.white, size: 24),
      ),
    );
  }
}

class PartnerPageTitle extends StatelessWidget {
  const PartnerPageTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.heading.copyWith(
        color: PartnerUiColors.brand,
        fontSize: 28,
        height: 1.03,
      ),
    );
  }
}

class PartnerCardActionRow extends StatelessWidget {
  const PartnerCardActionRow({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 66,
        child: Row(
          children: [
            Icon(icon, color: PartnerUiColors.brand, size: 28),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: PartnerUiColors.brand,
                  fontSize: 38 / 2,
                ),
              ),
            ),
            trailing ??
                const Icon(
                  Icons.chevron_right_rounded,
                  color: PartnerUiColors.brand,
                  size: 36,
                ),
          ],
        ),
      ),
    );
  }
}

class PartnerInfoRow extends StatelessWidget {
  const PartnerInfoRow({
    required this.label,
    required this.value,
    this.compact = false,
    super.key,
  });

  final String label;
  final String value;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: compact ? 14 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.sectionTitle.copyWith(
                color: PartnerUiColors.brand,
                fontSize: 34 / 2,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.sectionTitle.copyWith(
                color: PartnerUiColors.brand,
                fontSize: 34 / 2,
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PartnerSettingsRow extends StatelessWidget {
  const PartnerSettingsRow({
    required this.label,
    this.value,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 68,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: PartnerUiColors.brand,
                  fontSize: 34 / 2,
                ),
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: PartnerUiColors.brand,
                  fontSize: 34 / 2,
                ),
              ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class PartnerSectionHeading extends StatelessWidget {
  const PartnerSectionHeading(this.text, {this.trailing, super.key});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: PartnerUiColors.brand,
              fontSize: 20,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class PartnerFieldLabel extends StatelessWidget {
  const PartnerFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.sectionTitle.copyWith(
        color: PartnerUiColors.brand,
        fontSize: 32 / 2,
      ),
    );
  }
}

class PartnerOutlinedField extends StatelessWidget {
  const PartnerOutlinedField(
    this.hint, {
    this.maxLines = 1,
    this.leading,
    this.trailing,
    super.key,
  });
  final String hint;
  final int maxLines;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final minHeight = maxLines == 1 ? 46.0 : 108.0;
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: PartnerUiColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PartnerUiColors.brand, width: 1),
      ),
      child: Row(
        crossAxisAlignment: maxLines == 1
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 10)],
          Expanded(
            child: Text(
              hint,
              style: AppTextStyles.sectionTitle.copyWith(
                color: PartnerUiColors.brand,
                fontSize: 32 / 2,
                height: 1.2,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class PartnerInputField extends StatelessWidget {
  const PartnerInputField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.sectionTitle.copyWith(
          color: PartnerUiColors.brand.withValues(alpha: 0.5),
          fontSize: 32 / 2,
        ),
        filled: true,
        fillColor: PartnerUiColors.panel,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: PartnerUiColors.brand, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: PartnerUiColors.brand, width: 2),
        ),
      ),
      style: AppTextStyles.sectionTitle.copyWith(
        color: PartnerUiColors.brand,
        fontSize: 32 / 2,
      ),
    );
  }
}

class PartnerPublishButton extends StatelessWidget {
  const PartnerPublishButton({
    required this.onTap,
    this.label = 'PUBLISH MY AD',
    super.key,
  });

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 42, maxWidth: 280),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: PartnerUiColors.brand,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            textStyle: AppTextStyles.button.copyWith(fontSize: 28 / 2),
          ),
          onPressed: onTap,
          child: textScaler.scale(1) > 1.15
              ? Text(
                  label,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(label, maxLines: 1),
                ),
        ),
      ),
    );
  }
}

class PartnerMissionTitleField extends StatefulWidget {
  const PartnerMissionTitleField({super.key});

  @override
  State<PartnerMissionTitleField> createState() =>
      _PartnerMissionTitleFieldState();
}

class _PartnerMissionTitleFieldState extends State<PartnerMissionTitleField> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PartnerUiColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PartnerUiColors.brand, width: 1),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Title of the local mission',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: PartnerUiColors.brand,
                        fontSize: 32 / 2,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: PartnerUiColors.brand,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(color: PartnerUiColors.brand, height: 1),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: PartnerUiColors.brand,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Balader des chiens',
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: PartnerUiColors.brand,
                          fontSize: 32 / 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 90,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: PartnerUiColors.brand,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Saisir',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: PartnerUiColors.brand,
                        fontSize: 32 / 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PartnerToggle extends StatelessWidget {
  const PartnerToggle({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.95,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: PartnerUiColors.brand,
        inactiveThumbColor: PartnerUiColors.brand,
        inactiveTrackColor: PartnerUiColors.panel,
      ),
    );
  }
}
