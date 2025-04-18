import 'package:equatable/equatable.dart';
import 'package:productly/features/product/data/models/product_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartLoaded extends CartEvent {
  const CartLoaded();
}

class CartItemAdded extends CartEvent {
  final ProductModel product;
  final int quantity;

  const CartItemAdded({
    required this.product,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [product, quantity];
}

class CartItemRemoved extends CartEvent {
  final int productId;

  const CartItemRemoved({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class CartItemUpdated extends CartEvent {
  final int productId;
  final int quantity;

  const CartItemUpdated({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

class CartCleared extends CartEvent {
  const CartCleared();
} 