import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/article.dart';
import '../viewmodels/headlines_view_model.dart';
import '../widgets/article_list_item.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import 'article_detail_page.dart';

class HeadlinesPage extends StatelessWidget {
  const HeadlinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HeadlinesViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HEADLINES',
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.loadHeadlines(forceRefresh: true),
        color: Colors.white,
        backgroundColor: Colors.black,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _buildBody(viewModel, context),
        ),
      ),
    );
  }

  Widget _buildBody(HeadlinesViewModel viewModel, BuildContext context) {
    switch (viewModel.status) {
      case HeadlinesStatus.initial:
      case HeadlinesStatus.loading:
        return const LoadingView(key: ValueKey('loading'));
      case HeadlinesStatus.loaded:
        return KeyedSubtree(
          key: const ValueKey('list'),
          child: _buildList(viewModel.articles, context),
        );
      case HeadlinesStatus.error:
        return KeyedSubtree(
          key: const ValueKey('error'),
          child: ErrorView(
            message: viewModel.errorMessage ??
                'Unable to load headlines. Pull to refresh.',
            onRetry: () => viewModel.loadHeadlines(),
          ),
        );
    }
  }

  Widget _buildList(List<Article> articles, BuildContext context) {
    if (articles.isEmpty) {
      return Center(
        child: Text(
          'No headlines available.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: articles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final article = articles[index];
        return ArticleListItem(
          article: article,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ArticleDetailPage(article: article),
              ),
            );
          },
        );
      },
    );
  }
}

