import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';

class FaqModel {
  final String id;
  final String question;
  final String answer;
  final String category;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['_id'] ?? json['id'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      category: json['category'] ?? 'GENERAL',
    );
  }
}

final faqProvider = FutureProvider<List<FaqModel>>((ref) async {
  final dio = ref.watch(dioProvider);
  // Fetch a large limit to get all FAQs for now. Adjust as needed.
  final response = await dio.get('/api/v1/faq', queryParameters: {
    'limit': 100,
  });

  if (response.statusCode == 200) {
    // Determine the structure. Usually it's response.data['data']['docs'] or similar for paginated endpoints
    // or just response.data['data'] if it's an array.
    final data = response.data;
    List<dynamic> items = [];

    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic> && data['data']['docs'] is List) {
        items = data['data']['docs'];
      } else if (data['data'] is List) {
        items = data['data'];
      } else if (data['docs'] is List) {
        items = data['docs'];
      } else {
        items = [];
      }
    } else if (data is List) {
      items = data;
    }

    return items.map((e) => FaqModel.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load FAQs');
  }
});
