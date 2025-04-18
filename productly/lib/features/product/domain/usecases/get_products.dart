import 'package:dartz/dartz.dart';
import 'package:productly/core/errors/failures.dart';
import 'package:productly/features/product/domain/entities/product.dart';
import 'package:productly/features/product/domain/repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<Either<Failure, List<Product>>> call() {
    return repository.getProducts();
  }
} 