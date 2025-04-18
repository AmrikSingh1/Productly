import 'package:dartz/dartz.dart';
import 'package:productly/core/errors/failures.dart';
import 'package:productly/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(int id);
  Future<Either<Failure, List<String>>> getCategories();
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);
} 