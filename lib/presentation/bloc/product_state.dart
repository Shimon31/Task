part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final List<ProductModel> allProducts;
  final List<ProductModel> filteredProducts;
  final List<int> favoriteIds;
  final String searchQuery;
  final bool isRefreshing;

  const ProductLoaded({
    required this.allProducts,
    required this.filteredProducts,
    required this.favoriteIds,
    this.searchQuery = '',
    this.isRefreshing = false,
  });

  ProductLoaded copyWith({
    List<ProductModel>? allProducts,
    List<ProductModel>? filteredProducts,
    List<int>? favoriteIds,
    String? searchQuery,
    bool? isRefreshing,
  }) {
    return ProductLoaded(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      searchQuery: searchQuery ?? this.searchQuery,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    allProducts,
    filteredProducts,
    favoriteIds,
    searchQuery,
    isRefreshing,
  ];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}