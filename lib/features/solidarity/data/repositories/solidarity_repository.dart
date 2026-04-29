import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/product_model.dart';
import '../models/shopify_collection_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SolidarityRepository {
  final ApiClient _apiClient;

  SolidarityRepository(this._apiClient);

  Future<List<ShopifyCollectionModel>> getCollections() async {
    final response = await _apiClient.get(ApiEndpoints.shopifyCollections);
    final List<dynamic> data = response.data['data'];
    return data.map((json) => ShopifyCollectionModel.fromJson(json)).toList();
  }

  Future<List<ProductModel>> getProducts({String? collectionId}) async {
    final Map<String, dynamic> queryParams = {};
    if (collectionId != null) {
      queryParams['collectionId'] = collectionId;
    }

    final response = await _apiClient.get(
      ApiEndpoints.shopifyProducts,
      queryParameters: queryParams,
    );
    
    final List<dynamic> data = response.data['data']['products'];
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }
}

final solidarityRepositoryProvider = Provider<SolidarityRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SolidarityRepository(apiClient);
});
