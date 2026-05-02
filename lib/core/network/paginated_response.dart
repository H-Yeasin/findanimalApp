class PaginatedResponse<T> {
  final List<T> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginatedResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginatedResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    final meta = json['meta'] ?? {};
    return PaginatedResponse(
      data: (json['data'] as List<dynamic>?)
              ?.where((item) => item is Map<String, dynamic>)
              .map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList() ??
          [],
      total: meta['total'] ?? 0,
      page: meta['page'] ?? 1,
      limit: meta['limit'] ?? 10,
      totalPages: meta['totalPages'] ?? 1,
    );
  }
}
