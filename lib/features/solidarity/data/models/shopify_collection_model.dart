class ShopifyCollectionModel {
  final int id;
  final String handle;
  final String title;
  final String? updatedAt;
  final String? bodyHtml;
  final String? publishedAt;
  final String? sortOrder;
  final String? templateSuffix;
  final String? publishedScope;
  final String? adminGraphqlApiId;

  ShopifyCollectionModel({
    required this.id,
    required this.handle,
    required this.title,
    this.updatedAt,
    this.bodyHtml,
    this.publishedAt,
    this.sortOrder,
    this.templateSuffix,
    this.publishedScope,
    this.adminGraphqlApiId,
  });

  factory ShopifyCollectionModel.fromJson(Map<String, dynamic> json) {
    return ShopifyCollectionModel(
      id: json['id'] as int,
      handle: json['handle'] as String,
      title: json['title'] as String,
      updatedAt: json['updated_at'] as String?,
      bodyHtml: json['body_html'] as String?,
      publishedAt: json['published_at'] as String?,
      sortOrder: json['sort_order'] as String?,
      templateSuffix: json['template_suffix'] as String?,
      publishedScope: json['published_scope'] as String?,
      adminGraphqlApiId: json['admin_graphql_api_id'] as String?,
    );
  }
}
