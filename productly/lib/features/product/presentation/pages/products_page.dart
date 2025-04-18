import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:productly/core/constants/app_constants.dart';
import 'package:productly/core/di/injection_container.dart';
import 'package:productly/core/storage/local_storage.dart';
import 'package:productly/core/widgets/app_error_widget.dart';
import 'package:productly/core/widgets/app_loading_widget.dart';
import 'package:productly/features/product/presentation/bloc/product_bloc.dart';
import 'package:productly/features/product/presentation/bloc/product_event.dart';
import 'package:productly/features/product/presentation/bloc/product_state.dart';
import 'package:productly/features/product/presentation/widgets/product_card.dart';

// Global key to access ProductsView state from anywhere
final GlobalKey<_ProductsViewState> productsViewKey = GlobalKey<_ProductsViewState>();

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductBloc>()..add(const GetProductsEvent()),
      child: ProductsView(key: productsViewKey),
    );
  }
}

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;
  int _cartCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCartCount();
  }

  // Public method to refresh the cart badge
  void refreshBadge() {
    _loadCartCount();
  }

  Future<void> _loadCartCount() async {
    final count = await LocalStorage.getCartItemCount();
    if (mounted) {
      setState(() {
        _cartCount = count;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _searchController.clear();
        context.read<ProductBloc>().add(const GetProductsEvent());
      }
    });
  }

  void _performSearch(String query) {
    if (query.length >= 2) {
      context.read<ProductBloc>().add(SearchProductsEvent(query: query));
    } else if (query.isEmpty) {
      context.read<ProductBloc>().add(const GetProductsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _showSearchBar
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                ),
                onChanged: _performSearch,
              )
            : const Text('Productly'),
        actions: [
          IconButton(
            icon: Icon(_showSearchBar ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: _cartCount > 0,
              label: Text('$_cartCount'),
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () async {
              await context.push(AppConstants.cartRoute);
              // Refresh cart count when returning from cart page
              _loadCartCount();
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push(AppConstants.profileRoute),
          ),
          IconButton(
            icon: const Icon(Icons.headphones),
            onPressed: () => context.push(AppConstants.audioPlayerRoute),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const AppLoadingWidget(message: 'Loading products...');
          } else if (state is ProductsLoaded) {
            return _buildProductsGrid(context, state);
          } else if (state is ProductsError) {
            return AppErrorWidget(
              message: state.message,
              actionText: 'Retry',
              onActionPressed: () {
                context.read<ProductBloc>().add(const GetProductsEvent());
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProductsGrid(BuildContext context, ProductsLoaded state) {
    if (state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No products found for "${_searchController.text}"'
                  : 'No products found',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (_searchController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  _searchController.clear();
                  context.read<ProductBloc>().add(const GetProductsEvent());
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Show all products'),
              ),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductBloc>().add(const GetProductsEvent());
          await _loadCartCount();
        },
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: AppConstants.gridCrossAxisCount,
            childAspectRatio: AppConstants.gridChildAspectRatio,
            crossAxisSpacing: AppConstants.gridCrossAxisSpacing,
            mainAxisSpacing: AppConstants.gridMainAxisSpacing,
          ),
          itemCount: state.products.length,
          itemBuilder: (context, index) {
            final product = state.products[index];
            return ProductCard(
              product: product,
              index: index,
              onTap: () {
                context.push(
                  '${AppConstants.productDetailsRoute}/${product.id}',
                  extra: product,
                );
              },
            );
          },
        ),
      ),
    );
  }
} 