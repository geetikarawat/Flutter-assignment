import '../../core/usecase/usecase.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetTopHeadlines implements UseCase<List<Article>, NoParams> {
  GetTopHeadlines(this.repository);

  final NewsRepository repository;

  @override
  Future<List<Article>> call(NoParams params) {
    return repository.getTopHeadlines();
  }
}

