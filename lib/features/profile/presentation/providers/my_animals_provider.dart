import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/my_animal_model.dart';
import '../../data/repositories/my_animals_repository.dart';

final myAnimalsProvider = FutureProvider.autoDispose<List<MyAnimalModel>>((
  ref,
) async {
  final repository = ref.watch(myAnimalsRepositoryProvider);
  return repository.getAll();
});
