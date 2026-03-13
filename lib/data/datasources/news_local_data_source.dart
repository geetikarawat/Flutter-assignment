import 'package:hive_flutter/hive_flutter.dart';

import '../models/article_model.dart';

abstract class NewsLocalDataSource {
  Future<void> cacheTopHeadlines(List<ArticleModel> articles);
  Future<List<ArticleModel>> getLastTopHeadlines();
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  NewsLocalDataSourceImpl({required HiveInterface hive}) : _hive = hive;

  final HiveInterface _hive;

  static const String _boxName = 'headlines_cache';
  static const String _keyArticles = 'articles';

  Future<Box> _openBox() async {
    return _hive.openBox<dynamic>(_boxName);
  }

  @override
  Future<void> cacheTopHeadlines(List<ArticleModel> articles) async {
    final box = await _openBox();
    await box.put(_keyArticles, ArticleModel.toJsonList(articles));
  }

  @override
  Future<List<ArticleModel>> getLastTopHeadlines() async {
    final box = await _openBox();
    final dynamic jsonList = box.get(_keyArticles);
    if (jsonList is List<dynamic>) {
      return ArticleModel.fromJsonList(jsonList);
    }
    return <ArticleModel>[];
  }
}

