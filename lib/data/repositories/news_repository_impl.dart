import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_local_data_source.dart';
import '../datasources/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl({
    required NewsRemoteDataSource remoteDataSource,
    required NewsLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  final NewsRemoteDataSource _remoteDataSource;
  final NewsLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<List<Article>> getTopHeadlines() async {
    final isConnected = await _networkInfo.isConnected;

    if (isConnected) {
      try {
        final remoteArticles = await _remoteDataSource.getTopHeadlines();
        await _localDataSource.cacheTopHeadlines(remoteArticles);
        return remoteArticles;
      } catch (_) {
        final cached = await _localDataSource.getLastTopHeadlines();
        if (cached.isNotEmpty) {
          return cached;
        }
        throw const ServerFailure(
          'Unable to load headlines from server.',
        );
      }
    } else {
      final cached = await _localDataSource.getLastTopHeadlines();
      if (cached.isNotEmpty) {
        return cached;
      }
      throw const CacheFailure(
        'No internet connection and no cached headlines.',
      );
    }
  }
}

