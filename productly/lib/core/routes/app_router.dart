import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:productly/core/constants/app_constants.dart';
import 'package:productly/features/audio_player/presentation/pages/audio_player_page.dart';
import 'package:productly/features/cart/presentation/pages/cart_page.dart';
import 'package:productly/features/checkout/presentation/pages/checkout_page.dart';
import 'package:productly/features/product/domain/entities/product.dart';
import 'package:productly/features/product/presentation/pages/product_details_page.dart';
import 'package:productly/features/product/presentation/pages/products_page.dart';
import 'package:productly/features/profile/presentation/pages/profile_page.dart';
import 'package:productly/features/user_form/presentation/pages/user_form_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppConstants.homeRoute,
    debugLogDiagnostics: true,
    routes: [
      // Home/Products Page
      GoRoute(
        path: AppConstants.homeRoute,
        name: 'home',
        builder: (context, state) => const ProductsPage(),
      ),
      
      // Product Details Page
      GoRoute(
        path: '${AppConstants.productDetailsRoute}/:productId',
        name: 'product-details',
        builder: (context, state) {
          final productId = int.parse(state.pathParameters['productId']!);
          final product = state.extra as Product?;
          return ProductDetailsPage(
            productId: productId,
            product: product,
          );
        },
      ),
      
      // User Form Page
      GoRoute(
        path: AppConstants.userFormRoute,
        name: 'user-form',
        builder: (context, state) => const UserFormPage(),
      ),
      
      // Audio Player Page
      GoRoute(
        path: AppConstants.audioPlayerRoute,
        name: 'audio-player',
        builder: (context, state) => const AudioPlayerPage(),
      ),
      
      // Cart Page
      GoRoute(
        path: AppConstants.cartRoute,
        name: 'cart',
        builder: (context, state) => const CartPage(),
      ),
      
      // Profile Page
      GoRoute(
        path: AppConstants.profileRoute,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      
      // Checkout Page
      GoRoute(
        path: AppConstants.checkoutRoute,
        name: 'checkout',
        builder: (context, state) => const CheckoutPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Oops! The page you are looking for does not exist.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.homeRoute),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
} 