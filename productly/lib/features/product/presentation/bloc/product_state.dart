import 'package:equatable/equatable.dart';
import 'package:productly/features/product/domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductsLoading extends ProductState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  
  const ProductsLoaded({required this.products});
  
  @override
  List<Object> get props => [products];
}

class ProductsError extends ProductState {
  final String message;
  
  const ProductsError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class ProductDetailsLoading extends ProductState {
  const ProductDetailsLoading();
}

class ProductDetailsLoaded extends ProductState {
  final Product product;
  
  const ProductDetailsLoaded({required this.product});
  
  @override
  List<Object> get props => [product];
}

class ProductDetailsError extends ProductState {
  final String message;
  
  const ProductDetailsError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class CategoriesLoading extends ProductState {
  const CategoriesLoading();
}

class CategoriesLoaded extends ProductState {
  final List<String> categories;
  
  const CategoriesLoaded({required this.categories});
  
  @override
  List<Object> get props => [categories];
}

class CategoriesError extends ProductState {
  final String message;
  
  const CategoriesError({required this.message});
  
  @override
  List<Object> get props => [message];
} 