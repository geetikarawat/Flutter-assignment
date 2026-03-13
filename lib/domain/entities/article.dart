class Article {
  const Article({
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.url,
    required this.publishedAt,
    required this.sourceName,
  });

  final String title;
  final String? description;
  final String? content;
  final String? imageUrl;
  final String? url;
  final DateTime? publishedAt;
  final String? sourceName;
}

