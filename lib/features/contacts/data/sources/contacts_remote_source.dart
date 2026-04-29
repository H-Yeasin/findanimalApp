import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_provider.dart';

final contactsRemoteSourceProvider = Provider<ContactsRemoteSource>((ref) {
  return ContactsRemoteSource(ref.watch(apiClientProvider));
});

class ContactsRemoteSource {
  const ContactsRemoteSource(this._apiClient);

  final ApiClient _apiClient;

  Future<void> getAllContacts() async {
    await _apiClient.get('/contacts/get-all-contacts');
  }
}
