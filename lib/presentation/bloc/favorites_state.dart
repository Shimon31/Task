part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoaded extends FavoritesState {
  final List<ProductModel> favoriteProducts;

  const FavoritesLoaded({required this.favoriteProducts});

  @override
  List<Object?> get props => [favoriteProducts];
}