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
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  int _limit = 10;

  ContactsNotifier(this._repository, this._type) : super(const AsyncValue.loading()) {
    fetchContacts();
  }

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalItems => _totalItems;
  int get limit => _limit;

  Future<void> fetchContacts({String? search, int? page}) async {
    state = const AsyncValue.loading();
    try {
      if (search != null) _searchQuery = search;
      if (page != null) _currentPage = page;

      final response = await _repository.getAllContacts(
        page: _currentPage,
        limit: _limit,
        type: _type,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      _totalPages = response.totalPages;
      _totalItems = response.total;
      _limit = response.limit;
      state = AsyncValue.data(response.data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _currentPage = 1;
    fetchContacts();
  }

  void goToPage(int page) {
    if (page < 1 || page > _totalPages || page == _currentPage) return;
    _currentPage = page;
    fetchContacts();
  }

  void nextPage() => goToPage(_currentPage + 1);

  void previousPage() => goToPage(_currentPage - 1);
}
