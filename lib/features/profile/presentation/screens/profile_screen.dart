import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hesteka_frontend/features/auth/presentation/providers/auth_provider.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../home/presentation/widgets/custom_bottom_navigation_bar.dart';
import '../providers/profile_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(myProfileProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: profileAsync.when(
        data: (profile) => Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(painter: _ProfileGridPainter()),
            ),
            SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppTopBar(),
                    const SizedBox(height: 14),
                    Text(
                      '${profile.firstName}${profile.lastName.isNotEmpty ? " ${profile.lastName[0]}." : ""}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFBA4A22),
                        fontFamily: 'Impact',
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: UserAvatar(
                        imageUrl: profile.profileImage?.secure_url,
                        radius: 68,
                        showBorder: true,
                        borderWidth: 5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.memberSince,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFBA4A22),
                        fontFamily: 'Impact',
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFE8D5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFBA4A22),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          _menuRow(
                            icon: Icons.person,
                            label: l10n.myProfileMyAnimals,
                            onTap: () =>
                                context.push(RouteNames.profileMyAnimals),
                          ),
                          const Divider(color: Color(0xFFBA4A22)),
                          _menuRow(
                            icon: Icons.campaign_outlined,
                            label: l10n.myReportsLabel,
                            onTap: () => context.push(RouteNames.myReports),
                          ),
                          const Divider(color: Color(0xFFBA4A22)),
                          _menuRow(
                            icon: Icons.volunteer_activism_outlined,
                            label: l10n.donationsMade,
                            onTap: () => context.push(RouteNames.myDonations),
                          ),
                          const Divider(color: Color(0xFFBA4A22)),
                          _menuRow(
                            icon: Icons.check_circle_outline_rounded,
                            label: l10n.myPoints,
                            onTap: () => context.push(RouteNames.profilePoints),
                          ),
                          const Divider(color: Color(0xFFBA4A22)),
                          _menuRow(
                            icon: Icons.settings,
                            label: l10n.settings,
                            onTap: () =>
                                context.push(RouteNames.profileSettings),
                          ),
                          const Divider(color: Color(0xFFBA4A22)),
                          _menuRow(
                            icon: Icons.notifications_none_rounded,
                            label: l10n.notifications,
                            trailing: Transform.scale(
                              scale: 0.95,
                              child: Switch(
                                value: _notificationsEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    _notificationsEnabled = value;
                                  });
                                },
                                activeThumbColor: Colors.white,
                                activeTrackColor: const Color(0xFFBA4A22),
                                inactiveThumbColor: const Color(0xFFBA4A22),
                                inactiveTrackColor: const Color(0xFFEFE8D5),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _notificationsEnabled = !_notificationsEnabled;
                              });
                            },
                          ),
                          const Divider(color: Color(0xFFBA4A22)),
                          _menuRow(
                            icon: Icons.logout,
                            label: l10n.logout,
                            onTap: () async {
                              await ref
                                  .read(authSessionProvider.notifier)
                                  .logout();
                              if (!context.mounted) return;
                              context.go(RouteNames.root);
                            },
                          ),
                          const SizedBox(height: 22),
                          Text(
                            l10n.inviteContacts,
                            style: const TextStyle(
                              color: Color(0xFFBA4A22),
                              fontFamily: 'Impact',
                              fontSize: 19,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(l10n.unknownError)),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
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
              break;
          }
        },
      ),
    );
  }

  Widget _menuRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 66,
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFBA4A22), size: 28),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFBA4A22),
                  fontFamily: 'Impact',
                  fontSize: 19,
                ),
              ),
            ),
            trailing ??
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFBA4A22),
                  size: 36,
                ),
          ],
        ),
      ),
    );
  }
}

class _ProfileGridPainter extends CustomPainter {
  const _ProfileGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE7DCCB)
      ..strokeWidth = 1;

    const xStep = 92.0;
    const yStep = 102.0;

    for (double x = 0; x <= size.width; x += xStep) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += yStep) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
