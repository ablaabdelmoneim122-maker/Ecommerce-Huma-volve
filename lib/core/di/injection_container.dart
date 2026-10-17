import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../storage/token_storage.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repos/auth_repo_impl.dart';
import '../../features/auth/domain/repos/auth_repo.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/home_service.dart';
import '../../features/home/data/repos/home_repo_impl.dart';
import '../../features/home/domain/repos/home_repo.dart';
import '../../features/home/domain/usecases/get_categories_usecase.dart';
import '../../features/home/domain/usecases/get_products_usecase.dart';
import '../../features/home/domain/usecases/get_product_by_id_usecase.dart';
import '../../features/home/logic/product_details_cubit.dart';


final sl = GetIt.instance;


void setupDI() {
  // Core
  sl.registerLazySingleton(() => TokenStorage());
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.escuelajs.co/api/v1',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));
    dio.interceptors.addAll([
      InterceptorsWrapper(onRequest: (options, handler) async {
        final token = await sl<TokenStorage>().read();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      }),
      PrettyDioLogger(),
    ]);
    return dio;
  });

  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl(), sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl()));

  // Home
  sl.registerLazySingleton(() => HomeService(sl()));
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));

  sl.registerLazySingleton(() => GetProductByIdUseCase(sl()));
  sl.registerFactory(() => ProductDetailsCubit(sl()));
}