import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/contact_model.dart';
import '../../data/repositories/contact_repository.dart';

final sheltersProvider = StateNotifierProvider<ContactsNotifier, AsyncValue<List<ContactModel>>>((ref) {
  return ContactsNotifier(ref.watch(contactRepositoryProvider), 'shelter');
});

final veterinariansProvider = StateNotifierProvider<ContactsNotifier, AsyncValue<List<ContactModel>>>((ref) {
  return ContactsNotifier(ref.watch(contactRepositoryProvider), 'veterinarian');
});

final partnersProvider = StateNotifierProvider<ContactsNotifier, AsyncValue<List<ContactModel>>>((ref) {
  return ContactsNotifier(ref.watch(contactRepositoryProvider), 'partner');
});

final authoritiesProvider = StateNotifierProvider<ContactsNotifier, AsyncValue<List<ContactModel>>>((ref) {
  return ContactsNotifier(ref.watch(contactRepositoryProvider), 'authority');
});

class ContactsNotifier extends StateNotifier<AsyncValue<List<ContactModel>>> {
  final ContactRepository _repository;
  final String _type;
  String _searchQuery = '';

  ContactsNotifier(this._repository, this._type) : super(const AsyncValue.loading()) {
    fetchContacts();
  }

  Future<void> fetchContacts({String? search}) async {
    state = const AsyncValue.loading();
    try {
      if (search != null) _searchQuery = search;
      
      final response = await _repository.getAllContacts(
        type: _type,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      state = AsyncValue.data(response.data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    fetchContacts();
  }
}
