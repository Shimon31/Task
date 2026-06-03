part of 'favorites_bloc.dart';


abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavoriteProductsEvent extends FavoritesEvent {
  final List<ProductModel> allProducts;
  final List<int> favoriteIds;

  const LoadFavoriteProductsEvent({
    required this.allProducts,
    required this.favoriteIds,
  });

  @override
  List<Object?> get props => [allProducts, favoriteIds];
}