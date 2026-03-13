import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/article.dart';
import '../widgets/loading_view.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroImage(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontWeight: FontWeight.w700,
                      fontSize: 32, // headline per spec
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (article.sourceName != null ||
                      article.publishedAt != null) ...[
                    Text(
                      _buildMeta(),
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey.shade400,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (article.description != null &&
                      article.description!.isNotEmpty) ...[
                    Text(
                      article.description!,
                      style: const TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.w400,
                        fontSize: 20, // close to 24dp spec
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    article.content ??
                        'Full content is not available for this article.',
                    style: const TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildMeta() {
    final parts = <String>[];
    if (article.sourceName != null && article.sourceName!.isNotEmpty) {
      parts.add(article.sourceName!);
    }
    if (article.publishedAt != null) {
      parts.add(
        '${article.publishedAt!.year}-'
        '${article.publishedAt!.month.toString().padLeft(2, '0')}-'
        '${article.publishedAt!.day.toString().padLeft(2, '0')}',
      );
    }
    return parts.join(' • ');
  }

  Widget _buildHeroImage() {
    if (article.imageUrl == null || article.imageUrl!.isEmpty) {
      return Container(
        color: Colors.grey.shade900,
        child: const Center(
          child: Icon(Icons.image_not_supported_outlined, size: 48),
        ),
      );
    }

    final heroTag = article.url ?? article.title;

    return Hero(
      tag: heroTag,
      child: CachedNetworkImage(
        imageUrl: article.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (_, __) => const LoadingView(),
        errorWidget: (_, __, ___) => Container(
          color: Colors.grey.shade900,
          child: const Center(
            child: Icon(Icons.broken_image_outlined, size: 40),
          ),
        ),
      ),
    );
  }
}

