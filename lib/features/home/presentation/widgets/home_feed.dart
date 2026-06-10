import 'package:flutter/material.dart';

import '../../../../core/widgets/app_top_bar.dart';
import 'home_community_helped_section.dart';
import 'home_filters_button.dart';
import 'home_header.dart';
import 'home_map_section.dart';
import 'home_reported_recently_section.dart';
import 'home_support_section.dart';

class HomeFeed extends StatelessWidget {
  const HomeFeed({
    super.key,
    required this.onLocateMe,
    required this.onOpenReports,
    required this.onOpenShop,
    required this.onOpenMission,
  });

  final VoidCallback onLocateMe;
  final VoidCallback onOpenReports;
  final VoidCallback onOpenShop;
  final VoidCallback onOpenMission;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const HomeTopHeader(),
              const HomeInfoBanner(),
              HomeMapSection(
                onLocateMe: onLocateMe,
                onExploreFullMap: onOpenReports,
              ),
              const HomeInlineFilters(),
              HomeReportedRecentlySection(onOpenReports: onOpenReports),
              const HomeCommunityHelpedSection(),
              HomeSupportSection(
                onOpenShop: onOpenShop,
                onOpenMission: onOpenMission,
              ),
            ],
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(child: AppTopBar(showBackButton: false)),
        ),
      ],
    );
  }
}
