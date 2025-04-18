import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class GetProductsEvent extends ProductEvent {
  const GetProductsEvent();
}

class GetProductDetailsEvent extends ProductEvent {
  final int id;

  const GetProductDetailsEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetCategoriesEvent extends ProductEvent {
  const GetCategoriesEvent();
}

class FilterByCategoryEvent extends ProductEvent {
  final String category;
  
  const FilterByCategoryEvent({required this.category});
  
  @override
  List<Object?> get props => [category];
}

class GetProductsByCategoryEvent extends ProductEvent {
  final String category;

  const GetProductsByCategoryEvent({required this.category});

  @override
  List<Object?> get props => [category];
}

class SearchProductsEvent extends ProductEvent {
  final String query;

  const SearchProductsEvent({required this.query});

  @override
  List<Object?> get props => [query];
} 