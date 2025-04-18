import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:productly/core/constants/app_constants.dart';
import 'package:productly/features/product/data/models/product_model.dart';

class LocalStorage {
  static Future<void> saveProducts(List<ProductModel> products) async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = products.map((product) => jsonEncode(product.toJson())).toList();
    await prefs.setStringList(AppConstants.productsKey, productsJson);
  }

  static Future<List<ProductModel>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getStringList(AppConstants.productsKey) ?? [];
    return productsJson
        .map((json) => ProductModel.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> saveCategories(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(AppConstants.categoriesKey, categories);
  }

  static Future<List<String>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(AppConstants.categoriesKey) ?? [];
  }

  static Future<void> saveUserProfile(Map<String, dynamic> userProfile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userKey, jsonEncode(userProfile));
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.userKey);
    if (userJson == null) return null;
    return jsonDecode(userJson) as Map<String, dynamic>;
  }

  static Future<void> saveCart(List<Map<String, dynamic>> cart) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = jsonEncode(cart);
    await prefs.setString(AppConstants.cartKey, cartJson);
  }

  static Future<List<Map<String, dynamic>>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(AppConstants.cartKey);
    if (cartJson == null) return [];
    final List<dynamic> decoded = jsonDecode(cartJson);
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> addToCart(ProductModel product, int quantity) async {
    final cart = await getCart();
    
    // Check if product already exists in cart
    final existingIndex = cart.indexWhere((item) => item['id'] == product.id);
    
    if (existingIndex >= 0) {
      // Update quantity if product already in cart
      cart[existingIndex]['quantity'] = (cart[existingIndex]['quantity'] as int) + quantity;
    } else {
      // Add new product to cart
      cart.add({
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.image,
        'quantity': quantity,
      });
    }
    
    await saveCart(cart);
  }

  static Future<void> removeFromCart(int productId) async {
    final cart = await getCart();
    cart.removeWhere((item) => item['id'] == productId);
    await saveCart(cart);
  }

  static Future<void> updateCartItemQuantity(int productId, int quantity) async {
    final cart = await getCart();
    final index = cart.indexWhere((item) => item['id'] == productId);
    
    if (index >= 0) {
      if (quantity <= 0) {
        cart.removeAt(index);
      } else {
        cart[index]['quantity'] = quantity;
      }
      await saveCart(cart);
    }
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.cartKey);
  }

  static Future<int> getCartItemCount() async {
    final cart = await getCart();
    if (cart.isEmpty) return 0;
    
    // Sum up all quantities in the cart
    int totalItems = 0;
    for (var item in cart) {
      totalItems += item['quantity'] as int;
    }
    return totalItems;
  }

  static Future<void> saveThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.themeKey, isDarkMode);
  }

  static Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.themeKey) ?? false;
  }
} 