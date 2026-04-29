import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/points_repository.dart';
import '../sources/points_remote_source.dart';

final pointsRepositoryProvider = Provider<PointsRepository>((ref) {
  return PointsRepositoryImpl(ref.watch(pointsRemoteSourceProvider));
});

class PointsRepositoryImpl implements PointsRepository {
  const PointsRepositoryImpl(this._remoteSource);

  final PointsRemoteSource _remoteSource;

  @override
  Future<void> getMyPoints() async {
    await _remoteSource.getMyPoints();
  }

  @override
  Future<void> redeemPoints() async {}
}
