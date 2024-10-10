import 'package:flutter_youtube_search/models/abstract/youtube_content.dart';

class YoutubeSearchResponse {
  final String? continuationKey;
  final List<YoutubeContent> contents;

  YoutubeSearchResponse({
    required this.continuationKey,
    required this.contents,
  });
}
