import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/paginated_response.dart';
import '../models/contact_model.dart';

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  return ContactRepository(ref.watch(apiClientProvider));
});

class ContactRepository {
  final ApiClient _apiClient;

  ContactRepository(this._apiClient);

  Future<PaginatedResponse<ContactModel>> getAllContacts({
    int page = 1,
    int limit = 10,
    String? type,
    String? status,
    String? search,
    String? city,
    String? country,
    String? sortBy,
    String? sort,
    String? from,
    String? to,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'limit': limit,
    };

    if (type != null) queryParams['type'] = type;
    if (status != null) queryParams['status'] = status;
    if (search != null) queryParams['search'] = search;
    if (city != null) queryParams['city'] = city;
    if (country != null) queryParams['country'] = country;
    if (sortBy != null) queryParams['sortBy'] = sortBy;
    if (sort != null) queryParams['sort'] = sort;
    if (from != null) queryParams['from'] = from;
    if (to != null) queryParams['to'] = to;
    if (latitude != null) queryParams['latitude'] = latitude;
    if (longitude != null) queryParams['longitude'] = longitude;
    if (radius != null) queryParams['radius'] = radius;

    final response = await _apiClient.get(
      ApiEndpoints.getAllContacts,
      queryParameters: queryParams,
    );

    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => ContactModel.fromJson(json),
    );
  }

  Future<ContactModel> getSingleContact(String id) async {
    final response = await _apiClient.get(ApiEndpoints.getSingleContact(id));
    return ContactModel.fromJson(
      (response.data as Map<String, dynamic>)['data'],
    );
  }

  Future<List<ContactModel>> getContactsByType(String type) async {
    final response = await _apiClient.get(ApiEndpoints.getContactsByType(type));
    final data = (response.data as Map<String, dynamic>)['data'] as List;
    return data.map((e) => ContactModel.fromJson(e)).toList();
  }
}
