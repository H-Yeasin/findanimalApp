import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/contacts_repository_impl.dart';

class ContactsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    await ref.read(contactsRepositoryProvider).getAllContacts();
  }
}

final contactsProvider = AsyncNotifierProvider<ContactsNotifier, void>(
  ContactsNotifier.new,
);
