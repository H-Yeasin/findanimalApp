import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../providers/solidarity_providers.dart';
import '../../data/models/product_model.dart';

class SolidarityShopScreen extends ConsumerWidget {
  const SolidarityShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopState = ref.watch(solidarityShopProvider);
    final shopNotifier = ref.read(solidarityShopProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF4E9),
      body: CustomPaint(
        painter: _GridPainter(),
        child: Column(
          children: [
            SafeArea(bottom: false, child: AppTopBar(showBackButton: true)),
            Expanded(
              child: DefaultTextStyle(
                style: const TextStyle(color: Color(0xFFBA4A22)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      _buildHeroSection(),
                      const SizedBox(height: 40),
                      _buildBestSellersSection(shopState.products),
                      const SizedBox(height: 40),
                      _buildEntireCollectionSection(
                        ref,
                        shopState.selectedCategory,
                        shopNotifier.filteredProducts,
                      ),
                      const SizedBox(height: 40),
                      _buildCommitmentsSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: const [
        Text(
          'Wearing Hesteka\nmeans taking action.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Impact',
            fontSize: 34,
            height: 1.1,
            color: Color(0xFFBA4A22),
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Every purchase makes a real\nimpact.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Impact',
            fontSize: 18,
            color: Color(0xFFBA4A22),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'T-shirts, sweaters, caps, socks, stickers — pieces designed\nfor animal lovers, made responsibly.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, height: 1.4, color: Color(0xFFBA4A22)),
        ),
        SizedBox(height: 20),
        Text(
          'Because style and commitment go hand in hand.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: Color(0xFFBA4A22)),
        ),
      ],
    );
  }

  Widget _buildBestSellersSection(List<ProductModel> products) {
    return Column(
      children: [
        const Text(
          'THE COMMUNITY HAS CHOSEN',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Impact',
            fontSize: 14,
            letterSpacing: 1.0,
            color: Color(0xFFBA4A22),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Best Sellers',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Impact',
            fontSize: 36,
            color: Color(0xFFBA4A22),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'The pieces the Hesteka community is snapping up.\nThe essentials of the solidarity shop.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, height: 1.4, color: Color(0xFFBA4A22)),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: products
                .map(
                  (p) => SizedBox(
                    width: 170,
                    height:
                        215, // Matched to the Solidarity Shop grid proportions
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _buildProductCard(p),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildEntireCollectionSection(
    WidgetRef ref,
    String selectedCategory,
    List<ProductModel> products,
  ) {
    final shopState = ref.watch(solidarityShopProvider);

    // Build category list: "SEE ALL" + titles from collections
    final List<String> categories = ['SEE ALL'];
    for (var collection in shopState.collections) {
      String title = collection.title.toUpperCase();
      if (title == 'TOUT VOIR') continue; // Skip since we have manual SEE ALL
      if (title == 'VÊTEMENTS') title = 'CLOTHING';
      if (title == 'ACCESSOIRES') title = 'ACCESSORIES';
      if (!categories.contains(title)) {
        categories.add(title);
      }
    }

    return Column(
      children: [
        const Text(
          'THE ENTIRE COLLECTION',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Impact',
            fontSize: 14,
            letterSpacing: 1.0,
            color: Color(0xFFBA4A22),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'The solidarity shop',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Impact',
            fontSize: 36,
            color: Color(0xFFBA4A22),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Pieces for enthusiasts, carefully made, serving a\ncause that matters.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, height: 1.4, color: Color(0xFFBA4A22)),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: categories
                  .map(
                    (cat) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () => ref
                            .read(solidarityShopProvider.notifier)
                            .setCategory(cat),
                        child: _buildFilterChip(
                          cat,
                          isSelected: selectedCategory == cat,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (shopState.isLoading)
          const Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(color: Color(0xFFBA4A22)),
          )
        else if (products.isEmpty)
          const Padding(
            padding: EdgeInsets.all(40.0),
            child: Text('No products in this category.'),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) => _buildProductCard(products[index]),
          ),
      ],
    );
  }

  Widget _buildCommitmentsSection() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFBA4A22),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Text(
            'WHAT WE BELIEVE IN',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Impact',
              fontSize: 16,
              letterSpacing: 1.0,
              color: Color(0xFFF9EAD4),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Our commitments',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Impact',
              fontSize: 36,
              color: Color(0xFFF9EAD4),
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  height: 150,
                  child: _buildCommitmentCard1(),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 200,
                  height: 150,
                  child: _buildCommitmentCard2(),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 200,
                  height: 150,
                  child: _buildCommitmentCard3(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () async {
        if (product.productUrl != null && product.productUrl!.isNotEmpty) {
          final uri = Uri.parse(product.productUrl!);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFBA4A22),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          children: [
            // Image area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9EAD4),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: product.imageUrl.isNotEmpty
                            ? Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Color(0xFFBA4A22),
                                      ),
                                    ),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.image,
                                  color: Color(0xFFBA4A22),
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFBA4A22),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Text area
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Impact',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    product.description.replaceAll(
                      RegExp(r'<[^>]*>|&nbsp;'),
                      '',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          product.formattedPrice,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Impact',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9EAD4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Add to cart',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBA4A22),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String text, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFBA4A22) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBA4A22), width: 1.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Impact',
          fontSize: 14,
          color: isSelected ? Colors.white : const Color(0xFFBA4A22),
        ),
      ),
    );
  }

  Widget _buildCommitmentCard1() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFC65D3B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: const [
          Text(
            'A portion for the\nanimals',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Impact',
              fontSize: 18,
              height: 1.1,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'A part of every sale is\ndonated to our partner\norganizations for care,\nshelters, and adoptions.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              height: 1.3,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommitmentCard2() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9EAD4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: const [
          Text(
            'Responsible\nmaterials',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Impact',
              fontSize: 18,
              height: 1.1,
              color: Color(0xFFBA4A22),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Organic cotton, 100%\nrecyclable packaging. We\npay attention to every detail.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              height: 1.3,
              color: Color(0xFFBA4A22),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommitmentCard3() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFBA4A22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF9EAD4), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Ethical\nproduction',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Impact',
              fontSize: 18,
              height: 1.1,
              color: Color(0xFFF9EAD4),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Certified workshops, workers\' rights respected, strict environmental standards at every stage.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              height: 1.3,
              color: Color(0xFFF9EAD4),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xFFEFE1D1)
      ..strokeWidth = 1.0;

    var brightPaint = Paint()
      ..color = const Color(0xFFF2DDBE).withValues(alpha: 0.5)
      ..strokeWidth = 1.5;

    double step = 30;

    for (double i = 0; i < size.width; i += step) {
      if ((i ~/ step) % 5 == 0 && i != 0) {
        canvas.drawLine(Offset(i, 0), Offset(i, size.height), brightPaint);
      } else {
        canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
      }
    }

    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
