import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import '../../core/network/dio_provider.dart';
import 'presentation/providers/faq_provider.dart';

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

  final List<Map<String, dynamic>> _faqData = [
    {
      'category': 'INITIAL',
      'title': '',
      'image': '',
      'questions': [
        'What should I do if I find an injured animal?',
        '.. How do you know if a found animal belongs to someone?',
        'What should I do if I cannot keep the found animal?',
      ],
    },
    {
      'category': 'REPORT',
      'title': 'REPORT',
      'image': 'assets/images/faq_image_1.png',
      'questions': [
        'Can I modify my report?',
        'Can I delete my ad?',
        'Is my report visible everywhere?',
      ],
    },
    {
      'category': 'LOCAL MISSIONS',
      'title': 'LOCAL MISSIONS',
      'image': 'assets/images/faq_image_2.png',
      'questions': [
        'How to participate in a mission?',
        'Is any special experience required?',
        'How do I find a mission near me?',
      ],
    },
    {
      'category': 'MY ACCOUNT',
      'title': 'MY ACCOUNT',
      'image': 'assets/images/faq_image_3.png',
      'questions': [
        'Is my data protected?',
        'Can I change my information?',
        'Can I log in on multiple devices?',
      ],
    },
    {
      'category': 'MESSAGING',
      'title': 'MESSAGING',
      'image': 'assets/images/faq_image_4.png',
      'questions': [
        'Can I block a user?',
        'How to start a conversation?',
        'How to start a conversation?',
      ],
    },
    {
      'category': 'DONATIONS AND HELP',
      'title': 'DONATIONS AND HELP',
      'image': 'assets/images/faq_image_5.png',
      'questions': [
        'Who do the donations go to?',
        'Are donations secure?',
        'Can I help in other ways?',
      ],
    },
    {
      'category': 'SECURITY',
      'title': 'SECURITY',
      'image': 'assets/images/faq_image_6.png',
      'questions': [
        'Is my data protected?',
        'Does the application verify the content?',
        'What to do in case of a problem?',
      ],
    },
  ];

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
      final response = await dio.get('/api/v1/settings');
      if (response.statusCode == 200) {
        String? email;
        if (response.data is Map<String, dynamic>) {
          if (response.data['data'] != null && response.data['data']['supportEmail'] != null) {
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

  Future<void> _contactSupport() async {
    final email = _supportEmail ?? 'support@emmafve.com'; // Fallback

    // Launch email intent
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Request',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email app')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const brandPrimary = Color(0xFFBA4A22);
    const surface = Color(0xFFFBF4E9);
    const cardBg = Color(0xFFFFF6E5);

    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: brandPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.undo,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _floatController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 5 * _floatController.value),
                          child: const Text(
                            'F.A.Q',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: brandPrimary,
                              fontFamily: 'Impact',
                              letterSpacing: 1.5,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: brandPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: brandPrimary,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              // Search Section
              const SizedBox(height: 20),
              const Text(
                'How can I help you?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: brandPrimary,
                ),
              ),
              const SizedBox(height: 10),
              _buildAnimatedSearchBar(brandPrimary, cardBg),

              const SizedBox(height: 20),
              const Text(
                'Frequently asked questions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: brandPrimary,
                ),
              ),
              const SizedBox(height: 15),

              // Filtered Content
              ..._faqData.map((section) {
                final filteredQuestions = section['questions']
                    .where(
                      (q) => q.toString().toLowerCase().contains(_searchQuery),
                    )
                    .toList();

                if (filteredQuestions.isEmpty) return const SizedBox.shrink();

                if (section['category'] == 'INITIAL') {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildFAQGrid(
                      List<String>.from(filteredQuestions),
                      cardBg,
                      brandPrimary,
                    ),
                  );
                }

                return _buildCategorySection(
                  section['title'],
                  section['image'],
                  List<String>.from(filteredQuestions),
                  cardBg,
                  brandPrimary,
                );
              }),

              const SizedBox(height: 40),
              ScrollAppearanceWrapper(
                type: AnimationType.bounce,
                child: Column(
                  children: [
                    const Text(
                      'We haven\'t answered your question?\nDon\'t hesitate to contact us',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                        onTap: _contactSupport,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 80),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: brandPrimary,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: brandPrimary.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _supportEmail ?? 'Contact support',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSearchBar(Color color, Color bg) {
    return ScrollAppearanceWrapper(
      type: AnimationType.fade,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Color(0xFFBA4A22), size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  color: Color(0xFFBA4A22),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search for a topic',
                  hintStyle: TextStyle(color: Color(0x80BA4A22), fontSize: 16),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQGrid(List<String> questions, Color cardBg, Color color) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 0.75,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: List.generate(questions.length, (index) {
        return ScrollAppearanceWrapper(
          type: AnimationType.flip,
          delay: Duration(milliseconds: index * 100),
          child: FAQInteractiveCard(
            text: questions[index],
            cardBg: cardBg,
            color: color,
          ),
        );
      }),
    );
  }

  Widget _buildCategorySection(
    String title,
    String imageUrl,
    List<String> questions,
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
              color: Colors.black.withOpacity(0.3),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontFamily: 'Impact',
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

class FAQInteractiveCard extends StatefulWidget {
  final String text;
  final Color cardBg;
  final Color color;

  const FAQInteractiveCard({
    super.key,
    required this.text,
    required this.cardBg,
    required this.color,
  });

  @override
  State<FAQInteractiveCard> createState() => _FAQInteractiveCardState();
}

class _FAQInteractiveCardState extends State<FAQInteractiveCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _isPressed ? widget.color.withOpacity(0.05) : widget.cardBg,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: widget.color.withOpacity(_isPressed ? 0.8 : 0.4),
              width: _isPressed ? 2.5 : 1.5,
            ),
            boxShadow: _isPressed
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}

enum AnimationType { fade, flip, bounce }

class ScrollAppearanceWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final AnimationType type;

  const ScrollAppearanceWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.type = AnimationType.fade,
  });

  @override
  State<ScrollAppearanceWrapper> createState() =>
      _ScrollAppearanceWrapperState();
}

class _ScrollAppearanceWrapperState extends State<ScrollAppearanceWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isVisible = false;
  final GlobalKey _key = GlobalKey();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
      _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
        _checkVisibility();
      });
    });
  }

  void _checkVisibility() {
    if (!mounted) return;

    final renderObject = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderObject == null) return;

    final position = renderObject.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    bool currentlyInView =
        position.dy < screenHeight - 20 && position.dy > -200;

    if (currentlyInView && !_isVisible) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          setState(() => _isVisible = true);
          _controller.forward();
        }
      });
    } else if (!currentlyInView && _isVisible) {
      setState(() {
        _isVisible = false;
      });
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkVisibility();
        return false;
      },
      child: KeyedSubtree(
        key: _key,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            switch (widget.type) {
              case AnimationType.flip:
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX((1 - _controller.value) * 1.5),
                  alignment: Alignment.center,
                  child: Opacity(opacity: _controller.value, child: child),
                );
              case AnimationType.bounce:
                return Transform.scale(
                  scale: Curves.elasticOut.transform(_controller.value),
                  child: Opacity(opacity: _controller.value, child: child),
                );
              case AnimationType.fade:
              default:
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - _controller.value)),
                  child: Opacity(opacity: _controller.value, child: child),
                );
            }
          },
          child: widget.child,
        ),
      ),
    );
  }
}
