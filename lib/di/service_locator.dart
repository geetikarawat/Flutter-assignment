import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/network/network_info.dart';
import '../data/datasources/news_local_data_source.dart';
import '../data/datasources/news_remote_data_source.dart';
import '../data/repositories/news_repository_impl.dart';
import '../domain/repositories/news_repository.dart';
import '../domain/usecases/get_top_headlines.dart';
import '../presentation/viewmodels/headlines_view_model.dart';
import '../services/api_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<HiveInterface>(() => Hive);

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );

  // Services
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(dio: sl<Dio>()),
  );

  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(hive: sl<HiveInterface>()),
  );

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl<NewsRemoteDataSource>(),
      localDataSource: sl<NewsLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<GetTopHeadlines>(
    () => GetTopHeadlines(sl<NewsRepository>()),
  );

  // View models
  sl.registerFactory<HeadlinesViewModel>(
    () => HeadlinesViewModel(getTopHeadlines: sl<GetTopHeadlines>()),
  );
}

