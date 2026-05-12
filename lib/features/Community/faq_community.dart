import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/core/widgets/app_background.dart';
import 'package:hesteka_frontend/core/widgets/app_top_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/network/dio_provider.dart';
import '../../core/localization/app_localizations.dart';
import 'domain/faq_model.dart';
import 'presentation/providers/faq_data_provider.dart';
import 'presentation/widgets/faq_flip_card.dart';
import 'presentation/widgets/faq_search_bar.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

class FAQCommunityScreen extends ConsumerStatefulWidget {
  const FAQCommunityScreen({super.key});

  @override
  ConsumerState<FAQCommunityScreen> createState() => _FAQCommunityScreenState();
}

class _FAQCommunityScreenState extends ConsumerState<FAQCommunityScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _pulseController;
  late AnimationController _floatController;
  String _searchQuery = '';

  String? _supportEmail;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSupportEmail();
    });
  }

  Future<void> _fetchSupportEmail() async {
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('/settings');
      if (response.statusCode == 200) {
        String? email;
        if (response.data is Map<String, dynamic>) {
          if (response.data['data'] != null &&
              response.data['data']['supportEmail'] != null) {
            email = response.data['data']['supportEmail'];
          } else if (response.data['supportEmail'] != null) {
            email = response.data['supportEmail'];
          }
        }
        if (email != null && mounted) {
          setState(() {
            _supportEmail = email;
          });
        }
      }
    } catch (e) {
      debugPrint('Failed to load support email on init: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Future<void> _contactSupport(dynamic l10n) async {
    final email = _supportEmail ?? 'support@emmafve.com';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query:
          'subject=${Uri.encodeComponent(AppLocalizations.of(context).faqSupportRequestSubject)}',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.unknownError)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    const brandPrimary = Color(0xFFBA4A22);
    const surface = Color(0xFFFBF4E9);
    const cardBg = Color(0xFFFFF6E5);

    final List<FAQSection> faqData = FAQDataProvider.getLocalizedFaqData(
      context,
    );

    return Scaffold(
      backgroundColor: surface,
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                AppTopBar(title: l10n.faqTitleLabel, showUserAvatar: false),
                const SizedBox(height: 20),
                Text(
                  l10n.howCanIHelp,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: brandPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                FAQSearchBar(
                  controller: _searchController,
                  brandPrimary: brandPrimary,
                  cardBg: cardBg,
                  l10n: l10n,
                ),

                const SizedBox(height: 20),
                Text(
                  l10n.faqSubtitle,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: AppTextStyles.body.copyWith(
                    fontSize: _responsiveSubtitleFont(screenWidth),
                    fontWeight: FontWeight.w900,
                    color: brandPrimary,
                  ),
                ),
                const SizedBox(height: 15),

                ...faqData.map((section) {
                  final filteredQuestions = section.questions
                      .where(
                        (q) =>
                            q.question.toLowerCase().contains(_searchQuery) ||
                            q.answer.toLowerCase().contains(_searchQuery),
                      )
                      .toList();

                  if (filteredQuestions.isEmpty) return const SizedBox.shrink();

                  if (section.category == 'INITIAL') {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildFAQGrid(
                        filteredQuestions,
                        cardBg,
                        brandPrimary,
                      ),
                    );
                  }

                  return _buildCategorySection(
                    section.title,
                    section.image,
                    filteredQuestions,
                    cardBg,
                    brandPrimary,
                  );
                }),

                const SizedBox(height: 40),
                _buildContactSection(l10n, brandPrimary),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _responsiveSubtitleFont(double width) {
    if (width < 360) return 13;
    if (width < 400) return 14;
    return 16;
  }

  Widget _buildContactSection(AppLocalizations l10n, Color brandPrimary) {
    return Column(
      children: [
        Text(
          l10n.faqContactText,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: brandPrimary,
          ),
        ),
        const SizedBox(height: 15),
        ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 1.05).animate(
            CurvedAnimation(
              parent: _pulseController,
              curve: Curves.easeInOut,
            ),
          ),
          child: GestureDetector(
            onTap: () => _contactSupport(l10n),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 80),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: brandPrimary,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: brandPrimary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                _supportEmail ?? l10n.contactSupport,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFAQGrid(List<FAQItem> questions, Color cardBg, Color color) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.85,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: List.generate(questions.length, (index) {
        return FAQFlipCard(
          question: questions[index].question,
          answer: questions[index].answer,
          cardBg: cardBg,
          color: color,
        );
      }),
    );
  }

  Widget _buildCategorySection(
    String title,
    String imageUrl,
    List<FAQItem> questions,
    Color cardBg,
    Color color,
  ) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              child: Image.asset(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 180,
              width: double.infinity,
              color: Colors.black.withValues(alpha: 0.3),
            ),
            Text(
              title,
              style: AppTextStyles.body.copyWith(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontFamily: 'EricaOne',
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildFAQGrid(questions, cardBg, color),
      ],
    );
  }
}
