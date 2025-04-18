import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoadSuccess extends CartState {
  final List<Map<String, dynamic>> items;
  final double totalPrice;

  const CartLoadSuccess({
    required this.items,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [items, totalPrice];
}

class CartOperationSuccess extends CartState {
  final String message;

  const CartOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class CartOperationFailure extends CartState {
  final String message;

  const CartOperationFailure({required this.message});

  @override
  List<Object?> get props => [message];
} 