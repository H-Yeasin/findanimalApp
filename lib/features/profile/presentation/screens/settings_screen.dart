import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/profile_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: profileAsync.when(
        data: (profile) => Stack(
          children: [
            const Positioned.fill(child: CustomPaint(painter: _GridPainter())),
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: profile.profileImage?.secure_url != null
                              ? NetworkImage(profile.profileImage!.secure_url!)
                              : const AssetImage('assets/images/profile_myprofile_mock.png') as ImageProvider,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.73),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 20,
                      child: InkWell(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 43,
                          height: 43,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFBA4A22),
                          ),
                          child: const Icon(Icons.undo, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: const Center(
                        child: Text(
                          'PERSONAL\nINFORMATION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Impact',
                            fontSize: 42,
                            height: 0.9,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Edit my information',
                            style: TextStyle(
                              color: Color(0xFFD8C89D),
                              fontFamily: 'Impact',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _infoRow('FIRST NAME', profile.firstName),
                        const Divider(color: Color(0xFFBA4A22), height: 1),
                        _infoRow('NAME', profile.lastName),
                        const Divider(color: Color(0xFFBA4A22), height: 1),
                        _infoRow('DATE OF BIRTH', '02/15/2003'), // Mock for now if not in backend
                        const Divider(color: Color(0xFFBA4A22), height: 1),
                        _infoRow('E-MAIL', profile.email),
                        const Divider(color: Color(0xFFBA4A22), height: 1),
                        _infoRow('PHONE', profile.phone),
                        const Divider(color: Color(0xFFBA4A22), height: 1),
                        _infoRow('ADDRESS', profile.address),
                        const SizedBox(height: 40),
                        Center(
                          child: SizedBox(
                            width: 232,
                            height: 42,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFBA4A22),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                textStyle: const TextStyle(
                                  fontFamily: 'Impact',
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {},
                              child: const Text('Admin access'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFBA4A22),
                fontFamily: 'Impact',
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFFBA4A22),
                fontFamily: 'Impact',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

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
