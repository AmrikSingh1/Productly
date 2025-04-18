import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:productly/core/constants/app_constants.dart';
import 'package:productly/core/storage/local_storage.dart';
import 'package:productly/features/product/data/models/product_model.dart';
import 'package:productly/features/product/domain/entities/product.dart';
import 'package:productly/features/product/presentation/pages/products_page.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;
  final bool animate;
  final int index;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.animate = true,
    this.index = 0,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }
  
  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
  
  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget card = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 - (_controller.value * 0.04),
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: _isHovering 
                    ? theme.colorScheme.shadow.withOpacity(0.2)
                    : theme.colorScheme.shadow.withOpacity(0.1),
                  blurRadius: _isHovering ? 8.0 : 4.0,
                  offset: Offset(0, _isHovering ? 4.0 : 2.0),
                  spreadRadius: _isHovering ? 0.5 : 0,
                ),
              ],
            ),
            child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
              ),
              child: Stack(
                children: [
                  // Main card content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      AspectRatio(
                        aspectRatio: 1,
                        child: Hero(
                          tag: 'product-image-${widget.product.id}',
                          child: CachedNetworkImage(
                            imageUrl: widget.product.image,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Container(
                              color: theme.colorScheme.surface,
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: theme.colorScheme.errorContainer,
                              child: Center(
                                child: Icon(
                                  Icons.error_outline,
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Product Info
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Title
                              Text(
                                widget.product.title,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  height: 1.2,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              
                              // Product Category
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(theme, widget.product.category),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  widget.product.category,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 10,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              
                              const Spacer(),
                              
                              // Row with Price and Rating
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Price
                                  Text(
                                    '\$${widget.product.price.toStringAsFixed(2)}',
                                    style: theme.textTheme.titleMedium?.copyWith(
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
                                        size: 16,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        widget.product.rating.rate.toString(),
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Quick add to cart button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: AnimatedOpacity(
                      opacity: _isHovering ? 1.0 : 0.8,
                      duration: const Duration(milliseconds: 200),
                      child: Material(
                        color: theme.colorScheme.primaryContainer.withOpacity(0.85),
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        elevation: _isHovering ? 3 : 1,
                        child: InkWell(
                          onTap: () => _quickAddToCart(context),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.add_shopping_cart,
                              size: 20,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.animate) {
      card = card
          .animate()
          .fadeIn(
            duration: AppConstants.defaultAnimationDuration,
            delay: Duration(milliseconds: 50 * widget.index),
          )
          .moveY(
            begin: 20,
            end: 0,
            duration: AppConstants.defaultAnimationDuration,
            delay: Duration(milliseconds: 50 * widget.index),
            curve: Curves.easeOutQuad,
          );
    }

    return card;
  }
  
  Color _getCategoryColor(ThemeData theme, String category) {
    switch(category.toLowerCase()) {
      case "electronics":
        return Colors.blue.withOpacity(0.2);
      case "jewelery":
        return Colors.amber.withOpacity(0.2);
      case "men's clothing":
        return Colors.indigo.withOpacity(0.2);
      case "women's clothing":
        return Colors.pink.withOpacity(0.2);
      default:
        return theme.colorScheme.surfaceVariant.withOpacity(0.5);
    }
  }
  
  Future<void> _quickAddToCart(BuildContext context) async {
    // Convert Product to ProductModel if needed
    final productModel = widget.product is ProductModel 
        ? widget.product as ProductModel 
        : ProductModel(
            id: widget.product.id,
            title: widget.product.title,
            price: widget.product.price,
            description: widget.product.description,
            category: widget.product.category,
            image: widget.product.image,
            rating: widget.product.rating,
          );
          
    // Add to cart with quantity 1
    await LocalStorage.addToCart(productModel, 1);
    
    // Show success message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to cart: ${widget.product.title}'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'VIEW CART',
            onPressed: () {
              context.push(AppConstants.cartRoute);
            },
          ),
        ),
      );
      
      // Refresh the cart badge on the products page
      productsViewKey.currentState?.refreshBadge();
    }
  }
} 