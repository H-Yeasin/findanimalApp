import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Header with Image
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?q=80&w=800', // Dog face
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: brandPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.undo, // Match the image's back arrow style
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'EricaOne',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.helpingTomorrowSubtitle,
                          style: const TextStyle(
                            color: Colors.white,
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
                style: const TextStyle(
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
                          style: TextStyle(
                            color: brandPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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
                            l10n.donationAmount(donation['amount'].toString()),
                            style: const TextStyle(
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
                      style: const TextStyle(color: Colors.red),
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
                    style: const TextStyle(
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
                child: Image.network(
                  'https://images.unsplash.com/photo-1543466835-00a7907e9de1?q=80&w=800', // Kitten image
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bottom descriptive text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                l10n.thanksCommunityText,
                textAlign: TextAlign.center,
                style: const TextStyle(
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
