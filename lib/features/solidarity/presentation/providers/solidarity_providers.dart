import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
import '../../data/models/shopify_collection_model.dart';
import '../../data/repositories/solidarity_repository.dart';

class SolidarityShopState {
  const SolidarityShopState({
    required this.products,
    required this.collections,
    required this.selectedCategory,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<ProductModel> products;
  final List<ShopifyCollectionModel> collections;
  final String selectedCategory; // Title of the selected category
  final bool isLoading;
  final String? errorMessage;

  SolidarityShopState copyWith({
    List<ProductModel>? products,
    List<ShopifyCollectionModel>? collections,
    String? selectedCategory,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SolidarityShopState(
      products: products ?? this.products,
      collections: collections ?? this.collections,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class SolidarityShopNotifier extends StateNotifier<SolidarityShopState> {
  final SolidarityRepository _repository;

  SolidarityShopNotifier(this._repository)
      : super(const SolidarityShopState(
          products: [],
          collections: [],
          selectedCategory: 'SEE ALL',
          isLoading: true,
        )) {
    _initialize();
  }

  Future<void> _initialize() async {
    await fetchCollections();
    await fetchProducts();
  }

  Future<void> fetchCollections() async {
    try {
      final collections = await _repository.getCollections();
      state = state.copyWith(collections: collections);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> fetchProducts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      String? collectionId;
      if (state.selectedCategory != 'SEE ALL') {
        final collection = state.collections.firstWhere(
          (c) => c.title.toUpperCase() == state.selectedCategory.toUpperCase(),
          orElse: () => state.collections.firstWhere(
            (c) => c.handle.toUpperCase() == state.selectedCategory.toUpperCase(),
            orElse: () => throw Exception('Collection not found'),
          ),
        );
        collectionId = collection.id.toString();
      }

      final products = await _repository.getProducts(collectionId: collectionId);
      state = state.copyWith(products: products, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      // Fallback: If we can't find the specific collection, try fetching all
      if (state.selectedCategory != 'SEE ALL') {
        final products = await _repository.getProducts();
        state = state.copyWith(products: products);
      }
    }
  }

  void setCategory(String category) {
    if (state.selectedCategory == category) return;
    state = state.copyWith(selectedCategory: category);
    fetchProducts();
  }

  List<ProductModel> get filteredProducts {
    // Since we fetch by collectionId from the API, we don't need to filter locally
    // but we can if we want to be safe or if "SEE ALL" is active and we want to show everything.
    return state.products;
  }
}

final solidarityShopProvider =
    StateNotifierProvider<SolidarityShopNotifier, SolidarityShopState>((ref) {
  final repository = ref.watch(solidarityRepositoryProvider);
  return SolidarityShopNotifier(repository);
});
