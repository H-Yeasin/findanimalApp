import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/my_animal_model.dart';

final myAnimalsRepositoryProvider = Provider<MyAnimalsRepository>((ref) {
  return MyAnimalsRepository(ref.watch(apiClientProvider));
});

class MyAnimalsRepository {
  const MyAnimalsRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<MyAnimalModel>> getAll() async {
    final response = await _apiClient.get(ApiEndpoints.getMyAnimals);
    final payload = response.data as Map<String, dynamic>;
    final items = payload['data'] as List<dynamic>? ?? const [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(MyAnimalModel.fromJson)
        .toList();
  }

  Future<MyAnimalModel> create({
    required String title,
    required String description,
    required String species,
    required String breed,
    required String gender,
    required String age,
    required String hasMicrochip,
    required String hasTattoo,
    required String hasCollarOrHarness,
    required MultipartFile image,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      'species': species,
      'breed': breed,
      'gender': gender,
      'age': age,
      'hasMicrochip': hasMicrochip,
      'hasTattoo': hasTattoo,
      'hasCollarOrHarness': hasCollarOrHarness,
      'image': image,
    });
    final response = await _apiClient.post(
      ApiEndpoints.createMyAnimal,
      data: formData,
    );
    final payload = response.data as Map<String, dynamic>;
    return MyAnimalModel.fromJson(payload['data'] as Map<String, dynamic>);
  }

  Future<MyAnimalModel> update({
    required String id,
    required String title,
    required String description,
    required String species,
    required String breed,
    required String gender,
    required String age,
    required String hasMicrochip,
    required String hasTattoo,
    required String hasCollarOrHarness,
    MultipartFile? image,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      'species': species,
      'breed': breed,
      'gender': gender,
      'age': age,
      'hasMicrochip': hasMicrochip,
      'hasTattoo': hasTattoo,
      'hasCollarOrHarness': hasCollarOrHarness,
      ...?(image == null ? null : {'image': image}),
    });
    final response = await _apiClient.patch(
      ApiEndpoints.updateMyAnimal(id),
      data: formData,
    );
    final payload = response.data as Map<String, dynamic>;
    return MyAnimalModel.fromJson(payload['data'] as Map<String, dynamic>);
  }
}
