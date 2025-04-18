import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:productly/features/product/domain/entities/product.dart';
import 'package:productly/features/product/domain/usecases/get_product_by_id.dart';
import 'package:productly/features/product/domain/usecases/get_products.dart';
import 'package:productly/features/product/presentation/bloc/product_event.dart';
import 'package:productly/features/product/presentation/bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final GetProductById getProductById;
  List<Product> _allProducts = [];

  ProductBloc({
    required this.getProducts,
    required this.getProductById,
  }) : super(const ProductInitial()) {
    on<GetProductsEvent>(_onGetProducts);
    on<GetProductDetailsEvent>(_onGetProductDetails);
    on<SearchProductsEvent>(_onSearchProducts);
  }

  Future<void> _onGetProducts(
    GetProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductsLoading());
    
    final result = await getProducts();
    
    result.fold(
      (failure) => emit(ProductsError(message: failure.message)),
      (products) {
        _allProducts = products;
        emit(ProductsLoaded(products: products));
      },
    );
  }

  Future<void> _onGetProductDetails(
    GetProductDetailsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductDetailsLoading());
    
    final result = await getProductById(Params(id: event.id));
    
    result.fold(
      (failure) => emit(ProductDetailsError(message: failure.message)),
      (product) => emit(ProductDetailsLoaded(product: product)),
    );
  }

  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductsLoading());
    
    final query = event.query.toLowerCase();
    
    if (query.isEmpty) {
      emit(ProductsLoaded(products: _allProducts));
      return;
    }
    
    // Search in cached products
    final searchResults = _allProducts.where((product) {
      return product.title.toLowerCase().contains(query) || 
             product.description.toLowerCase().contains(query) ||
             product.category.toLowerCase().contains(query);
    }).toList();
    
    emit(ProductsLoaded(products: searchResults));
  }
}