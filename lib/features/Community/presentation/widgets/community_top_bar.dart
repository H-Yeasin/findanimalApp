import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/app_top_bar.dart';

class CommunityPinnedTopBar extends StatelessWidget {
  const CommunityPinnedTopBar({
    required this.brandPrimary,
    required this.profileImage,
    super.key,
  });

  final Color brandPrimary;
  final String? profileImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: AppTopBar(
        showBackButton: false,
        leftWidget: IconButton(
          icon: Icon(
            Icons.notifications_none,
            color: brandPrimary,
            shadows: [
              BoxShadow(
                color: brandPrimary.withValues(alpha: 0.25),
                offset: const Offset(0, 4),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
            size: 30,
          ),
          onPressed: () => context.push(RouteNames.mainNotifications),
        ),
        userImageUrl: profileImage,
      ),
    );
  }
}
