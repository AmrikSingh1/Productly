import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:productly/core/constants/app_constants.dart';
import 'package:productly/core/di/injection_container.dart';
import 'package:productly/core/storage/local_storage.dart';
import 'package:productly/core/widgets/app_button.dart';
import 'package:productly/core/widgets/app_error_widget.dart';
import 'package:productly/core/widgets/app_loading_widget.dart';
import 'package:productly/features/product/data/models/product_model.dart';
import 'package:productly/features/product/domain/entities/product.dart';
import 'package:productly/features/product/presentation/bloc/product_bloc.dart';
import 'package:productly/features/product/presentation/bloc/product_event.dart';
import 'package:productly/features/product/presentation/bloc/product_state.dart';
import 'package:productly/features/product/presentation/pages/products_page.dart';

class ProductDetailsPage extends StatelessWidget {
  final int productId;
  final Product? product;

  const ProductDetailsPage({
    super.key,
    required this.productId,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductBloc>()..add(GetProductDetailsEvent(id: productId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
        ),
        body: product != null
            ? ProductDetailsView(product: product!)
            : const ProductDetailsFetchView(),
      ),
    );
  }
}

class ProductDetailsFetchView extends StatelessWidget {
  const ProductDetailsFetchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductDetailsLoading) {
          return const AppLoadingWidget(message: 'Loading product details...');
        } else if (state is ProductDetailsLoaded) {
          return ProductDetailsView(product: state.product);
        } else if (state is ProductDetailsError) {
          return AppErrorWidget(
            message: state.message,
            actionText: 'Go Back',
            onActionPressed: () => context.pop(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class ProductDetailsView extends StatelessWidget {
  final Product product;

  const ProductDetailsView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Hero(
                tag: 'product-image-${product.id}',
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.error,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ).animate()
              .fadeIn(duration: AppConstants.defaultAnimationDuration)
              .moveY(
                begin: 20,
                end: 0,
                duration: AppConstants.defaultAnimationDuration,
              ),
            
            const SizedBox(height: 24),
            
            // Product Title
            Text(
              product.title,
              style: theme.textTheme.headlineSmall,
            ).animate()
              .fadeIn(
                duration: AppConstants.defaultAnimationDuration,
                delay: const Duration(milliseconds: 100),
              ),
            
            const SizedBox(height: 8),
            
            // Product Category
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                product.category,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ).animate()
              .fadeIn(
                duration: AppConstants.defaultAnimationDuration,
                delay: const Duration(milliseconds: 150),
              ),
            
            const SizedBox(height: 16),
            
            // Product Price and Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                // Rating
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product.rating.rate} (${product.rating.count})',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ).animate()
              .fadeIn(
                duration: AppConstants.defaultAnimationDuration,
                delay: const Duration(milliseconds: 200),
              ),
            
            const SizedBox(height: 24),
            
            // Description Title
            Text(
              'Description',
              style: theme.textTheme.titleMedium,
            ).animate()
              .fadeIn(
                duration: AppConstants.defaultAnimationDuration,
                delay: const Duration(milliseconds: 250),
              ),
            
            const SizedBox(height: 8),
            
            // Description
            Text(
              product.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ).animate()
              .fadeIn(
                duration: AppConstants.defaultAnimationDuration,
                delay: const Duration(milliseconds: 300),
              ),
            
            const SizedBox(height: 32),
            
            // Add to Cart Button
            Builder(
              builder: (context) {
                return AppButton(
                  text: 'Add to Cart',
                  onPressed: () async {
                    // Convert Product to ProductModel if needed
                    final productModel = product is ProductModel 
                        ? product as ProductModel 
                        : ProductModel(
                            id: product.id,
                            title: product.title,
                            price: product.price,
                            description: product.description,
                            category: product.category,
                            image: product.image,
                            rating: product.rating,
                          );
                    
                    // Add to cart with quantity 1
                    await LocalStorage.addToCart(productModel, 1);
                    
                    if (context.mounted) {
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added to cart: ${product.title}'),
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(
                            label: 'View Cart',
                            onPressed: () {
                              context.push(AppConstants.cartRoute);
                            },
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      
                      // Refresh the cart badge on the products page
                      productsViewKey.currentState?.refreshBadge();
                    }
                  },
                  isFullWidth: true,
                  icon: Icons.shopping_cart,
                );
              }
            ).animate()
              .fadeIn(
                duration: AppConstants.defaultAnimationDuration,
                delay: const Duration(milliseconds: 350),
              ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
} 