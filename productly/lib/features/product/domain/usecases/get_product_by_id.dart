import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:productly/core/errors/failures.dart';
import 'package:productly/features/product/domain/entities/product.dart';
import 'package:productly/features/product/domain/repositories/product_repository.dart';

class GetProductById {
  final ProductRepository repository;

  GetProductById(this.repository);

  Future<Either<Failure, Product>> call(Params params) {
    return repository.getProductById(params.id);
  }
}

class Params extends Equatable {
  final int id;

  const Params({required this.id});

  @override
  List<Object> get props => [id];
}