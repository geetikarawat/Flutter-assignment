import '../models/article_model.dart';
import '../../services/api_client.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines();
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  NewsRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<ArticleModel>> getTopHeadlines() async {
    final response = await _apiClient.get(
      '/top-headlines',
      queryParameters: <String, dynamic>{
        'country': 'us',
        'pageSize': 30,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final articlesJson = data['articles'] as List<dynamic>? ?? <dynamic>[];
    return ArticleModel.fromJsonList(articlesJson);
  }
}

