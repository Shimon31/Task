import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_theme.dart';
import '../bloc/product_bloc.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/product_card.dart';
import '../widgets/product_loading_grid.dart';
import '../widgets/search_bar_widget.dart';
import 'favorites_screen.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const ProductLoadingGrid();
          }
          if (state is ProductError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () =>
                  context.read<ProductBloc>().add(const LoadProductsEvent()),
            );
          }
          if (state is ProductLoaded) {
            return _ProductListContent(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProductListContent extends StatelessWidget {
  final ProductLoaded state;

  const _ProductListContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () async {
        context.read<ProductBloc>().add(const RefreshProductsEvent());
        await Future.delayed(const Duration(milliseconds: 1500));
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SearchBarWidget(
              initialValue: state.searchQuery,
              onChanged: (query) => context
                  .read<ProductBloc>()
                  .add(SearchProductsEvent(query)),
            ),
          ),
          if (state.isRefreshing)
            const SliverToBoxAdapter(
              child: LinearProgressIndicator(
                color: AppTheme.primaryColor,
                backgroundColor: Colors.transparent,
              ),
            ),
          if (state.filteredProducts.isEmpty)
            SliverFillRemaining(
              child: EmptyStateWidget(
                title: state.searchQuery.isEmpty
                    ? 'No Products Found'
                    : 'No results for "${state.searchQuery}"',
                subtitle: state.searchQuery.isEmpty
                    ? 'Pull down to refresh.'
                    : 'Try a different search term.',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final product = state.filteredProducts[index];
                    return ProductCard(
                      product: product,
                      isFavorite: state.favoriteIds.contains(product.id),
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
                  childCount: state.filteredProducts.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}