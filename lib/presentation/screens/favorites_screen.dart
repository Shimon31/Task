import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_theme.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/product_bloc.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, productState) {
        if (productState is ProductLoaded) {
          context.read<FavoritesBloc>().add(LoadFavoriteProductsEvent(
            allProducts: productState.allProducts,
            favoriteIds: productState.favoriteIds,
          ));
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Favorites')),
          body: BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state is FavoritesLoaded) {
                if (state.favoriteProducts.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'No Favorites Yet',
                    subtitle:
                    'Tap the heart icon on any product to save it here.',
                    icon: Icons.favorite_border_rounded,
                  );
                }

                final favoriteIds = productState is ProductLoaded
                    ? productState.favoriteIds
                    : <int>[];

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: state.favoriteProducts.length,
                  itemBuilder: (context, index) {
                    final product = state.favoriteProducts[index];
                    return ProductCard(
                      product: product,
                      isFavorite: favoriteIds.contains(product.id),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ProductBloc>(),
                            child: ProductDetailScreen(product: product),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator(
                    color: AppTheme.primaryColor),
              );
            },
          ),
        );
      },
    );
  }
}