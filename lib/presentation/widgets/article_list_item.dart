import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/article.dart';
import 'loading_view.dart';

class ArticleListItem extends StatelessWidget {
  const ArticleListItem({
    super.key,
    required this.article,
    required this.onTap,
  });

  final Article article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final heroTag = article.url ?? article.title;

    return InkWell(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: heroTag,
              child: _buildBackgroundImage(),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article.sourceName != null &&
                        article.sourceName!.isNotEmpty)
                      Text(
                        article.sourceName!.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'RobotoSlab',
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.redAccent,
                          letterSpacing: 2,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.w700,
                        fontSize: 24, // close to 25–32dp spec
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (article.publishedAt != null)
                      Text(
                        _formatDate(article.publishedAt!),
                        style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    if (article.imageUrl == null || article.imageUrl!.isEmpty) {
      return Container(color: Colors.grey.shade800);
    }

    return CachedNetworkImage(
      imageUrl: article.imageUrl!,
      fit: BoxFit.cover,
      placeholder: (_, __) => const LoadingView(),
      errorWidget: (_, __, ___) => Container(color: Colors.grey.shade800),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }
}

