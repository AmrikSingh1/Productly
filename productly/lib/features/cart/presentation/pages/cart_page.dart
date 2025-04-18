import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:productly/core/constants/app_constants.dart';
import 'package:productly/core/di/injection_container.dart';
import 'package:productly/core/widgets/app_button.dart';
import 'package:productly/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:productly/features/cart/presentation/bloc/cart_event.dart';
import 'package:productly/features/cart/presentation/bloc/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CartBloc>()..add(const CartLoaded()),
      child: const CartView(),
    );
  }
}

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoadSuccess && state.items.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear Cart'),
                        content: const Text('Are you sure you want to clear your cart?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.read<CartBloc>().add(const CartCleared());
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is CartOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoadSuccess) {
            if (state.items.isEmpty) {
              return _buildEmptyCart(theme, context);
            }
            return _buildCartItems(theme, context, state);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoadSuccess && state.items.isNotEmpty) {
            return _buildCheckoutBar(theme, context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyCart(ThemeData theme, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to your cart to see them here',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Browse Products',
            onPressed: () => context.go(AppConstants.homeRoute),
            icon: Icons.shopping_bag_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(
    ThemeData theme,
    BuildContext context,
    CartLoadSuccess state,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        final itemTotal = (item['price'] as double) * (item['quantity'] as int);
        
        return Dismissible(
          key: Key('cart-item-${item['id']}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          onDismissed: (_) => context.read<CartBloc>().add(
                CartItemRemoved(productId: item['id'] as int),
              ),
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: AppConstants.defaultElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: item['image'] as String,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (_, __, ___) => const Icon(Icons.error_outline),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: theme.textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${(item['price'] as double).toStringAsFixed(2)}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Quantity Selector
                            Row(
                              children: [
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: OutlinedButton(
                                    onPressed: () => context.read<CartBloc>().add(
                                          CartItemUpdated(
                                            productId: item['id'] as int,
                                            quantity: (item['quantity'] as int) - 1,
                                          ),
                                        ),
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    child: const Icon(Icons.remove, size: 16),
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    '${item['quantity']}',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: OutlinedButton(
                                    onPressed: () => context.read<CartBloc>().add(
                                          CartItemUpdated(
                                            productId: item['id'] as int,
                                            quantity: (item['quantity'] as int) + 1,
                                          ),
                                        ),
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    child: const Icon(Icons.add, size: 16),
                                  ),
                                ),
                              ],
                            ),
                            
                            // Item Total
                            Text(
                              '\$${itemTotal.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckoutBar(
    ThemeData theme,
    BuildContext context,
    CartLoadSuccess state,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total:',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    '\$${state.totalPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            AppButton(
              text: 'Checkout',
              onPressed: () {
                context.push(AppConstants.checkoutRoute);
              },
              icon: Icons.payment,
            ),
          ],
        ),
      ),
    );
  }
} 