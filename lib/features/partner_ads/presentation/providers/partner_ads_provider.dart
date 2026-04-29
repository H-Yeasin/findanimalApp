import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/partner_ads_repository_impl.dart';

class PartnerAdsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    await ref.read(partnerAdsRepositoryProvider).getAllPartnerAds();
  }
}

final partnerAdsProvider = AsyncNotifierProvider<PartnerAdsNotifier, void>(
  PartnerAdsNotifier.new,
);
