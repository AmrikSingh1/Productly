import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:productly/core/storage/local_storage.dart';
import 'package:productly/features/cart/presentation/bloc/cart_event.dart';
import 'package:productly/features/cart/presentation/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartInitial()) {
    on<CartLoaded>(_onCartLoaded);
    on<CartItemAdded>(_onCartItemAdded);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<CartItemUpdated>(_onCartItemUpdated);
    on<CartCleared>(_onCartCleared);
  }

  Future<void> _onCartLoaded(
    CartLoaded event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    try {
      final cartItems = await LocalStorage.getCart();
      double total = 0;
      
      for (var item in cartItems) {
        total += (item['price'] as double) * (item['quantity'] as int);
      }
      
      emit(CartLoadSuccess(items: cartItems, totalPrice: total));
    } catch (e) {
      emit(CartOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onCartItemAdded(
    CartItemAdded event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    try {
      await LocalStorage.addToCart(event.product, event.quantity);
      add(const CartLoaded());
      emit(CartOperationSuccess(
        message: '${event.product.title} added to cart',
      ));
    } catch (e) {
      emit(CartOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onCartItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    try {
      await LocalStorage.removeFromCart(event.productId);
      add(const CartLoaded());
      emit(const CartOperationSuccess(message: 'Item removed from cart'));
    } catch (e) {
      emit(CartOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onCartItemUpdated(
    CartItemUpdated event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    try {
      await LocalStorage.updateCartItemQuantity(
        event.productId,
        event.quantity,
      );
      add(const CartLoaded());
      emit(const CartOperationSuccess(message: 'Cart updated'));
    } catch (e) {
      emit(CartOperationFailure(message: e.toString()));
    }
  }

  Future<void> _onCartCleared(
    CartCleared event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    try {
      await LocalStorage.clearCart();
      add(const CartLoaded());
      emit(const CartOperationSuccess(message: 'Cart cleared'));
    } catch (e) {
      emit(CartOperationFailure(message: e.toString()));
    }
  }
} 