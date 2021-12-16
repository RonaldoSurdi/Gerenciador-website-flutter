class YoutubeModel {
  YoutubeModel({
    required this.title,
    required this.authorName,
    required this.authorUrl,
    required this.type,
    required this.height,
    required this.width,
    required this.version,
    required this.providerName,
    required this.providerUrl,
    required this.thumbnailHeight,
    required this.thumbnailWidth,
    required this.thumbnailUrl,
    required this.html,
    required this.url,
    required this.description,
  });

  final String? title;
  final String? authorName;
  final String? authorUrl;
  final String? type;
  final int? height;
  final int? width;
  final String? version;
  final String? providerName;
  final String? providerUrl;
  final int? thumbnailHeight;
  final int? thumbnailWidth;
  final String? thumbnailUrl;
  final String? html;
  final String? url;
  final String? description;

  factory YoutubeModel.fromMap(Map<String, dynamic> json) => YoutubeModel(
        title: json["title"],
        authorName: json["author_name"],
        authorUrl: json["author_url"],
        type: json["type"],
        height: json["height"],
        width: json["width"],
        version: json["version"],
        providerName: json["provider_name"],
        providerUrl: json["provider_url"],
        thumbnailHeight: json["thumbnail_height"],
        thumbnailWidth: json["thumbnail_width"],
        thumbnailUrl: json["thumbnail_url"],
        html: json["html"],
        url: json["url"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "author_name": authorName,
        "author_url": authorUrl,
        "type": type,
        "height": height,
        "width": width,
        "version": version,
        "provider_name": providerName,
        "provider_url": providerUrl,
        "thumbnail_height": thumbnailHeight,
        "thumbnail_width": thumbnailWidth,
        "thumbnail_url": thumbnailUrl,
        "html": html,
        "url": url,
        "description": description,
      };
}
