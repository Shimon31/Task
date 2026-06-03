part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends ProductEvent {
  const LoadProductsEvent();
}

class RefreshProductsEvent extends ProductEvent {
  const RefreshProductsEvent();
}

class SearchProductsEvent extends ProductEvent {
  final String query;
  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleFavoriteEvent extends ProductEvent {
  final int productId;
  const ToggleFavoriteEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class LoadFavoritesEvent extends ProductEvent {
  const LoadFavoritesEvent();
}