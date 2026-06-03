import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_model.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesInitial()) {
    on<LoadFavoriteProductsEvent>(_onLoadFavoriteProducts);
  }

  void _onLoadFavoriteProducts(
      LoadFavoriteProductsEvent event,
      Emitter<FavoritesState> emit,
      ) {
    final favoriteProducts = event.allProducts
        .where((product) => event.favoriteIds.contains(product.id))
        .toList();
    emit(FavoritesLoaded(favoriteProducts: favoriteProducts));
  }
}