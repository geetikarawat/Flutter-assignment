import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.title,
    required super.description,
    required super.content,
    required super.imageUrl,
    required super.url,
    required super.publishedAt,
    required super.sourceName,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final source = json['source'] as Map<String, dynamic>?;
    return ArticleModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      content: json['content'] as String?,
      imageUrl: json['urlToImage'] as String?,
      url: json['url'] as String?,
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'] as String)
          : null,
      sourceName: source?['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'content': content,
      'urlToImage': imageUrl,
      'url': url,
      'publishedAt': publishedAt?.toIso8601String(),
      'source': <String, dynamic>{
        'name': sourceName,
      },
    };
  }

  static List<ArticleModel> fromJsonList(List<dynamic> list) {
    return list
        .whereType<Map<String, dynamic>>()
        .map(ArticleModel.fromJson)
        .toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<ArticleModel> articles) {
    return articles.map((e) => e.toJson()).toList();
  }
}

