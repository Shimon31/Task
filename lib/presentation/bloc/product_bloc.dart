import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(const ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<RefreshProductsEvent>(_onRefreshProducts);
    on<SearchProductsEvent>(_onSearchProducts);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<LoadFavoritesEvent>(_onLoadFavorites);
  }

  Future<void> _onLoadProducts(
      LoadProductsEvent event,
      Emitter<ProductState> emit,
      ) async {
    emit(const ProductLoading());

    final productsResult = await repository.getProducts();
    final favoritesResult = await repository.getFavoriteIds();

    productsResult.fold(
          (error) => emit(ProductError(error)),
          (products) {
        final favoriteIds =
        favoritesResult.fold((_) => <int>[], (ids) => ids);
        emit(ProductLoaded(
          allProducts: products,
          filteredProducts: products,
          favoriteIds: favoriteIds,
        ));
      },
    );
  }

  Future<void> _onRefreshProducts(
      RefreshProductsEvent event,
      Emitter<ProductState> emit,
      ) async {
    final currentState = state;
    if (currentState is ProductLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    }

    final productsResult = await repository.getProducts();
    final favoritesResult = await repository.getFavoriteIds();

    productsResult.fold(
          (error) => emit(ProductError(error)),
          (products) {
        final favoriteIds =
        favoritesResult.fold((_) => <int>[], (ids) => ids);
        final query =
        currentState is ProductLoaded ? currentState.searchQuery : '';
        final filtered = _filterProducts(products, query);
        emit(ProductLoaded(
          allProducts: products,
          filteredProducts: filtered,
          favoriteIds: favoriteIds,
          searchQuery: query,
        ));
      },
    );
  }

  void _onSearchProducts(
      SearchProductsEvent event,
      Emitter<ProductState> emit,
      ) {
    final currentState = state;
    if (currentState is! ProductLoaded) return;

    final filtered = _filterProducts(currentState.allProducts, event.query);
    emit(currentState.copyWith(
      filteredProducts: filtered,
      searchQuery: event.query,
    ));
  }

  Future<void> _onToggleFavorite(
      ToggleFavoriteEvent event,
      Emitter<ProductState> emit,
      ) async {
    final currentState = state;
    if (currentState is! ProductLoaded) return;

    final result = await repository.toggleFavorite(
      event.productId,
      currentState.favoriteIds,
    );

    result.fold(
          (_) {},
          (_) {
        final updatedIds = List<int>.from(currentState.favoriteIds);
        if (updatedIds.contains(event.productId)) {
          updatedIds.remove(event.productId);
        } else {
          updatedIds.add(event.productId);
        }
        emit(currentState.copyWith(favoriteIds: updatedIds));
      },
    );
  }

  Future<void> _onLoadFavorites(
      LoadFavoritesEvent event,
      Emitter<ProductState> emit,
      ) async {
    final currentState = state;
    if (currentState is! ProductLoaded) return;

    final result = await repository.getFavoriteIds();
    result.fold(
          (_) {},
          (ids) => emit(currentState.copyWith(favoriteIds: ids)),
    );
  }

  List<ProductModel> _filterProducts(
      List<ProductModel> products, String query) {
    if (query.trim().isEmpty) return products;
    final lowerQuery = query.toLowerCase();
    return products
        .where((p) => p.title.toLowerCase().contains(lowerQuery))
        .toList();
  }
}