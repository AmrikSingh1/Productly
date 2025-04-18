import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:productly/core/errors/exceptions.dart';
import 'package:productly/core/errors/failures.dart';
import 'package:productly/core/network/network_info.dart';
import 'package:productly/core/storage/local_storage.dart';
import 'package:productly/features/product/data/datasources/product_remote_data_source.dart';
import 'package:productly/features/product/data/models/product_model.dart';
import 'package:productly/features/product/domain/entities/product.dart';
import 'package:productly/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        // Get from remote
        final remoteProducts = await remoteDataSource.getProducts();
        
        // Cache the products
        await LocalStorage.saveProducts(remoteProducts);
        
        return Right(remoteProducts);
      } catch (e) {
        // Try getting from cache if remote fails
        return _getProductsFromCache();
      }
    } else {
      // Get from cache if no connection
      return _getProductsFromCache();
    }
  }

  Future<Either<Failure, List<Product>>> _getProductsFromCache() async {
    try {
      final localProducts = await LocalStorage.getProducts();
      if (localProducts.isEmpty) {
        return const Left(CacheFailure(message: 'No cached products found.'));
      }
      return Right(localProducts);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDataSource.getProductById(id);
        return Right(remoteProduct);
      } catch (e) {
        // Try finding in cache if remote fails
        return _getProductByIdFromCache(id);
      }
    } else {
      // Get from cache if no connection
      return _getProductByIdFromCache(id);
    }
  }

  Future<Either<Failure, Product>> _getProductByIdFromCache(int id) async {
    try {
      final localProducts = await LocalStorage.getProducts();
      final product = localProducts.firstWhere((product) => product.id == id);
      return Right(product);
    } catch (e) {
      return Left(CacheFailure(message: 'Product not found in cache.'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCategories = await remoteDataSource.getCategories();
        
        // Cache the categories
        await LocalStorage.saveCategories(remoteCategories);
        
        return Right(remoteCategories);
      } catch (e) {
        // Try getting from cache if remote fails
        return _getCategoriesFromCache();
      }
    } else {
      // Get from cache if no connection
      return _getCategoriesFromCache();
    }
  }

  Future<Either<Failure, List<String>>> _getCategoriesFromCache() async {
    try {
      final localCategories = await LocalStorage.getCategories();
      if (localCategories.isEmpty) {
        return const Left(CacheFailure(message: 'No cached categories found.'));
      }
      return Right(localCategories);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getProductsByCategory(category);
        return Right(remoteProducts);
      } catch (e) {
        // Try filtering cached products if remote fails
        return _getProductsByCategoryFromCache(category);
      }
    } else {
      // Filter cached products if no connection
      return _getProductsByCategoryFromCache(category);
    }
  }

  Future<Either<Failure, List<Product>>> _getProductsByCategoryFromCache(String category) async {
    try {
      final localProducts = await LocalStorage.getProducts();
      final filteredProducts = localProducts
          .where((product) => product.category.toLowerCase() == category.toLowerCase())
          .toList();
      
      if (filteredProducts.isEmpty) {
        return const Left(CacheFailure(message: 'No products found for this category.'));
      }
      
      return Right(filteredProducts);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
} 