class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.category = 'CLOTHING',
    this.productUrl,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String? productUrl;

  String get formattedPrice => '€${price.toStringAsFixed(2)}';

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Shopify product structure mapping
    final variants = json['variants'] as List<dynamic>?;
    final images = json['images'] as List<dynamic>?;
    
    double extractedPrice = 0.0;
    if (variants != null && variants.isNotEmpty) {
      extractedPrice = double.tryParse(variants[0]['price'].toString()) ?? 0.0;
    }

    String extractedImageUrl = '';
    if (images != null && images.isNotEmpty) {
      extractedImageUrl = images[0]['src'] as String;
    }

    return ProductModel(
      id: json['id'].toString(),
      name: json['title'] as String? ?? 'No Title',
      description: json['body_html'] as String? ?? '',
      price: extractedPrice,
      imageUrl: extractedImageUrl,
      productUrl: json['productUrl'] as String?,
      category: 'CLOTHING', // Default, will be updated by collection logic
    );
  }
}
