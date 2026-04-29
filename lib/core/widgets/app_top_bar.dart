import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../routing/route_names.dart';
import 'user_avatar.dart';

class AppTopBar extends ConsumerWidget {
  final Widget? leftWidget;
  final String? title;
  final VoidCallback? onBack;
  final bool showBackButton;
  final bool showUserAvatar;
  final String? userImageUrl;
  final Color brandColor;

  const AppTopBar({
    super.key,
    this.leftWidget,
    this.title,
    this.onBack,
    this.showBackButton = true,
    this.showUserAvatar = true,
    this.userImageUrl,
    this.brandColor = const Color(0xFFBA4A22),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authStateProvider);
    final user = ref.watch(currentUserProvider);
    final imageUrl = userImageUrl ?? user?.profileImage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (leftWidget != null)
                leftWidget!
              else if (showBackButton)
                CustomBackButton(onPressed: onBack, color: brandColor)
              else
                const SizedBox(width: 43),
              if (showUserAvatar)
                TopBarUserAvatar(imageUrl: imageUrl, brandColor: brandColor)
              else
                const SizedBox(width: 43),
            ],
          ),
          if (title != null)
            Text(
              title!.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: brandColor,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                fontFamily: 'Impact',
                letterSpacing: 1.2,
              ),
            ),
        ],
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color color;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.color = const Color(0xFFBA4A22),
  });

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
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              offset: Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: const Icon(Icons.undo, color: Colors.white, size: 24),
      ),
    );
  }
}

class TopBarUserAvatar extends ConsumerWidget {
  final String? imageUrl;
  final Color brandColor;

  const TopBarUserAvatar({
    super.key,
    this.imageUrl,
    this.brandColor = const Color(0xFFBA4A22),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authStateProvider);
    final user = ref.watch(currentUserProvider);
    final finalImageUrl = imageUrl ?? user?.profileImage;

    return InkWell(
      onTap: () {
        if (authStatus == AuthStatus.authenticated) {
          if (user?.role == 'partners') {
            context.push(RouteNames.partnerAccess);
          } else {
            context.push(RouteNames.myProfile);
          }
        } else {
          context.push(RouteNames.account);
        }
      },
      customBorder: const CircleBorder(),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              offset: const Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: UserAvatar(
          imageUrl: finalImageUrl,
          radius: 19,
          borderColor: brandColor,
          boxShadow: const [],
        ),
      ),
    );
  }
}
