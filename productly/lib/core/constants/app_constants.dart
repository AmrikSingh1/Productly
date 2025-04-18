class AppConstants {
  // API Base URLs
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String productsUrl = '$baseUrl/products';
  static const String singleProductUrl = '$baseUrl/products/';
  static const String categoriesUrl = '$baseUrl/products/categories';
  static const String categoryProductsUrl = '$baseUrl/products/category/';
  
  // App Constants
  static const String appName = 'Productly';
  static const String appVersion = '1.0.0';
  
  // Navigation Routes
  static const String homeRoute = '/';
  static const String productDetailsRoute = '/product-details';
  static const String userFormRoute = '/user-form';
  static const String audioPlayerRoute = '/audio-player';
  static const String cartRoute = '/cart';
  static const String profileRoute = '/profile';
  static const String checkoutRoute = '/checkout';
  
  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String userKey = 'user_data';
  static const String productsKey = 'cached_products';
  static const String categoriesKey = 'cached_categories';
  static const String cartKey = 'shopping_cart';
  static const String searchHistoryKey = 'search_history';
  
  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultElevation = 2.0;
  
  // Product Grid Constants
  static const int gridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 0.60;
  static const double gridCrossAxisSpacing = 16.0;
  static const double gridMainAxisSpacing = 16.0;
} 