import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hesteka_frontend/core/config/app_assets.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final bool showBorder;
  final double borderWidth;
  final Color borderColor;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.radius = 22,
    this.showBorder = true,
    this.borderWidth = 2,
    this.borderColor = const Color(0xFFBA4A22),
    required List<BoxShadow> boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: showBorder ? EdgeInsets.all(borderWidth) : null,
      decoration: showBorder
          ? BoxDecoration(color: borderColor, shape: BoxShape.circle)
          : null,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: borderColor,
        backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImageProvider(imageUrl!)
            : null,
        child: imageUrl == null || imageUrl!.isEmpty
            ? Image.asset(
                AppAssets.accountIcon,
                width: radius * 1.1,
                height: radius * 1.1,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.person, color: Colors.white, size: radius * 1.1),
              )
            : null,
      ),
    );
  }
}
