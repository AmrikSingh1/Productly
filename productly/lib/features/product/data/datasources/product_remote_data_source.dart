import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:productly/core/constants/app_constants.dart';
import 'package:productly/core/errors/exceptions.dart';
import 'package:productly/features/product/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(int id);
  Future<List<String>> getCategories();
  Future<List<ProductModel>> getProductsByCategory(String category);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(
      Uri.parse(AppConstants.productsUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw ServerException(
        message: 'Failed to load products',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await client.get(
      Uri.parse('${AppConstants.singleProductUrl}$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
        message: 'Failed to load product details',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await client.get(
      Uri.parse(AppConstants.categoriesUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => json.toString()).toList();
    } else {
      throw ServerException(
        message: 'Failed to load categories',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final response = await client.get(
      Uri.parse('${AppConstants.categoryProductsUrl}$category'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw ServerException(
        message: 'Failed to load products for category',
        statusCode: response.statusCode,
      );
    }
  }
} 