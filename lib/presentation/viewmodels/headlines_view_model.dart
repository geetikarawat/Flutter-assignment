import 'package:flutter/foundation.dart';

import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../../domain/entities/article.dart';
import '../../domain/usecases/get_top_headlines.dart';

enum HeadlinesStatus {
  initial,
  loading,
  loaded,
  error,
}

class HeadlinesViewModel extends ChangeNotifier {
  HeadlinesViewModel({required GetTopHeadlines getTopHeadlines})
      : _getTopHeadlines = getTopHeadlines;

  final GetTopHeadlines _getTopHeadlines;

  HeadlinesStatus _status = HeadlinesStatus.initial;
  List<Article> _articles = <Article>[];
  String? _errorMessage;

  HeadlinesStatus get status => _status;
  List<Article> get articles => List.unmodifiable(_articles);
  String? get errorMessage => _errorMessage;

  Future<void> loadHeadlines({bool forceRefresh = false}) async {
    _status = HeadlinesStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _getTopHeadlines(const NoParams());
      _articles = result;
      _status = HeadlinesStatus.loaded;
      notifyListeners();
    } catch (e) {
      _status = HeadlinesStatus.error;
      if (e is Failure) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Something went wrong. Please try again.';
      }
      notifyListeners();
    }
  }
}

