import 'package:hesteka_frontend/core/config/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/core/theme/app_colors.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';
import 'package:hesteka_frontend/core/widgets/app_background.dart';
import 'package:hesteka_frontend/core/widgets/app_top_bar.dart';
import 'package:hesteka_frontend/features/solidarity/presentation/screens/make_donation_screen.dart';
import '../../../../core/routing/route_names.dart';
import '../../../home/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/donation_provider.dart';
import '../../../../core/localization/app_localizations.dart';

class MyDonationsScreen extends ConsumerWidget {
  const MyDonationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    const brandPrimary = Color(0xFFBA4A22);
    const _ = Color(0xFFFFF6E5);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF4E9),
      body: AppBackground(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Header with Image
                  Stack(
                    children: [
                      Container(
                        height: 220,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppAssets.supportHeader),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Color.fromARGB(255, 43, 41, 41),
                              BlendMode.dstATop,
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          child: AppTopBar(showUserAvatar: false),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40),
                              Text(
                                l10n.donateTodayTitle,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.heading.copyWith(
                                  fontSize: 32,
                                  color: AppColors.surface,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                l10n.helpingTomorrowSubtitle,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.surface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // "My donations" title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      l10n.myDonationsTitle,
                      style: AppTextStyles.body.copyWith(
                        color: brandPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'EricaOne',
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Empty state message or list of donations
                  ref
                      .watch(myDonationsProvider)
                      .when(
                        data: (donations) {
                          if (donations.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                l10n.noDonationsMade,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body.copyWith(
                                  color: brandPrimary,
                                  fontSize: 14,
                                  // fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: donations.length,
                            itemBuilder: (context, index) {
                              final donation = donations[index];
                              return ListTile(
                                title: Text(
                                  l10n.donationAmount(
                                    donation['amount'].toString(),
                                  ),
                                  style: AppTextStyles.body.copyWith(
                                    color: brandPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  l10n.donationMethodStatus(
                                    donation['method'].toString(),
                                    donation['status'].toString(),
                                  ),
                                ),
                                trailing: Text(
                                  donation['createdAt'] != null
                                      ? DateTime.parse(
                                          donation['createdAt'],
                                        ).toLocal().toString().split(' ')[0]
                                      : '',
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(color: brandPrimary),
                        ),
                        error: (err, stack) => Center(
                          child: Text(
                            '${l10n.unknownError}: $err',
                            style: AppTextStyles.body.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),

                  const SizedBox(height: 30),

                  // "MAKE A DONATION" button
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MakeDonationScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: brandPrimary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          l10n.makeDonation.toUpperCase(),
                          style: AppTextStyles.body.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Bottom Image (Kitten)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(AppAssets.supportCat),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bottom descriptive text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      l10n.thanksCommunityText,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: brandPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 100), // Bottom nav padding
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2, // Highlight profile or solidarity?
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(RouteNames.root);
              break;
            case 1:
              context.go(RouteNames.mainReports);
              break;
            case 3:
              context.go(RouteNames.mainCommunity);
              break;
            case 4:
              context.go(RouteNames.mainSolidarity);
              break;
            case 2:
              context.go(RouteNames.mainProfile);
              break;
          }
        },
      ),
    );
  }
}
