import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/contacts_repository.dart';
import '../sources/contacts_remote_source.dart';

final contactsRepositoryProvider = Provider<ContactsRepository>((ref) {
  return ContactsRepositoryImpl(ref.watch(contactsRemoteSourceProvider));
});

class ContactsRepositoryImpl implements ContactsRepository {
  const ContactsRepositoryImpl(this._remoteSource);

  final ContactsRemoteSource _remoteSource;

  @override
  Future<void> getAllContacts() async {
    await _remoteSource.getAllContacts();
  }
}
