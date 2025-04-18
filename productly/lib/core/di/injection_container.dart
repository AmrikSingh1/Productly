import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:productly/core/network/network_info.dart';
import 'package:productly/features/audio_player/presentation/bloc/audio_player_bloc.dart';
import 'package:productly/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:productly/features/product/data/datasources/product_remote_data_source.dart';
import 'package:productly/features/product/data/repositories/product_repository_impl.dart';
import 'package:productly/features/product/domain/repositories/product_repository.dart';
import 'package:productly/features/product/domain/usecases/get_product_by_id.dart';
import 'package:productly/features/product/domain/usecases/get_products.dart';
import 'package:productly/features/product/presentation/bloc/product_bloc.dart';
import 'package:productly/features/user_form/presentation/bloc/user_form_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());

  // Features
  _initProductsFeature();
  _initUserFormFeature();
  _initAudioPlayerFeature();
  _initCartFeature();
}

void _initProductsFeature() {
  // Bloc
  sl.registerFactory(
    () => ProductBloc(
      getProducts: sl(),
      getProductById: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductById(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );
}

void _initUserFormFeature() {
  // Bloc
  sl.registerFactory(() => UserFormBloc());
}

void _initAudioPlayerFeature() {
  // Bloc
  sl.registerFactory(() => AudioPlayerBloc());
}

void _initCartFeature() {
  // Bloc
  sl.registerFactory(() => CartBloc());
} 