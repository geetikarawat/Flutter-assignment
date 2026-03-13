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
            pinned: true,import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/article.dart';
import '../widgets/loading_view.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final heroTag = article.url ?? article.title;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: screenHeight * 0.55,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: heroTag,
                    child: _buildImage(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.35, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 24,
                    child: Text(
                      article.title,
                      style: const TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Color(0xFFF2F2F2),
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 64,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.sourceName != null ||
                      article.publishedAt != null) ...[
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (article.sourceName != null &&
                            article.sourceName!.isNotEmpty)
                          Text(
                            article.sourceName!,
                            style: const TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Color(0xFFBABABA),
                            ),
                          ),
                        const Spacer(),
                        if (article.publishedAt != null)
                          Text(
                            _formatDate(article.publishedAt!),
                            style: const TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Color(0xFFBABABA),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (article.description != null &&
                      article.description!.isNotEmpty) ...[
                    Text(
                      article.description!,
                      style: const TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFFBABABA),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (article.content != null &&
                      article.content!.isNotEmpty)
                    Text(
                      article.content!,
                      style: const TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFFBABABA),
                        height: 1.5,
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

  String _formatDate(DateTime dt) {
    return '${dt.year}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';
  }

  Widget _buildImage() {
    if (article.imageUrl == null || article.imageUrl!.isEmpty) {
      return Container(
        color: Colors.grey.shade900,
        child: const Center(
          child: Icon(Icons.image_not_supported_outlined, size: 48),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: article.imageUrl!,
      fit: BoxFit.cover,
      placeholder: (_, __) => const LoadingView(),
      errorWidget: (_, __, ___) => Container(
        color: Colors.grey.shade900,
        child: const Center(
          child: Icon(Icons.broken_image_outlined, size: 40),
        ),
      ),
    );
  }
}

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

