import 'package:flutter_youtube_search/core/extensions/map_extension.dart';
import 'package:flutter_youtube_search/models/abstract/youtube_content.dart';

class YoutubeVideo extends YoutubeContent {
  final String id;
  final String title;
  final String? publishedTime;
  final String? duration;
  final ViewCountDetails viewCount;
  final List<Thumbnail> thumbnails;
  final List<DescriptionSnippet> descriptionSnippet;
  final ChannelDetails channelDetails;

  YoutubeVideo({
    required this.id,
    required this.title,
    required this.publishedTime,
    required this.duration,
    required this.viewCount,
    required this.thumbnails,
    required this.descriptionSnippet,
    required this.channelDetails,
  });

  factory YoutubeVideo.fromMap(Map<String, dynamic> map) {
    final thumbnails = map.getNestedValue(['thumbnail', 'thumbnails']) ?? [];
    final description = map.getNestedValue(
            ['detailedMetadataSnippets', 0, 'snippetText', 'runs']) ??
        [];
    return YoutubeVideo(
      id: map.getNestedValue(['videoId']),
      title: map.getNestedValue(['title', 'runs'])[0]['text'],
      publishedTime: map.getNestedValue(['publishedTimeText', 'simpleText']),
      duration: map.getNestedValue(['lengthText', 'simpleText']),
      viewCount: ViewCountDetails.fromMap(map),
      thumbnails: thumbnails.map<Thumbnail>(Thumbnail.fromMap).toList(),
      descriptionSnippet: description
          .map<DescriptionSnippet>(DescriptionSnippet.fromMap)
          .toList(),
      channelDetails: ChannelDetails.fromMap(map),
    );
  }
}

class Thumbnail {
  final String url;
  final int width;
  final int height;

  Thumbnail({required this.url, required this.width, required this.height});

  factory Thumbnail.fromMap(map) {
    return Thumbnail(
      url: map['url'],
      width: map['width'],
      height: map['height'],
    );
  }
}

class ViewCountDetails {
  final String text;
  final String shortText;

  ViewCountDetails({required this.text, required this.shortText});

  factory ViewCountDetails.fromMap(Map<String, dynamic> map) {
    if ((map['viewCountText'] as Map?)?.containsKey('runs') ?? false) {
      final text =
          (map['viewCountText']['runs'] as List).map((e) => e['text']).join("");
      return ViewCountDetails(
        text: text,
        shortText: text,
      );
    }
    return ViewCountDetails(
      text: map.getNestedValue(['viewCountText', 'simpleText']) ?? '',
      shortText: map.getNestedValue(['shortViewCountText', 'simpleText']) ?? '',
    );
  }
}

class ChannelDetails {
  final String name;
  final String id;
  final List<Thumbnail> thumbnails;

  ChannelDetails({
    required this.name,
    required this.id,
    required this.thumbnails,
  });

  factory ChannelDetails.fromMap(Map<String, dynamic> map) {
    return ChannelDetails(
      id: map.getNestedValue([
        'ownerText',
        'runs',
        0,
        'navigationEndpoint',
        'browseEndpoint',
        'browseId'
      ]),
      name: map.getNestedValue(['ownerText', 'runs', 0, 'text']) ?? '',
      thumbnails: (map.getNestedValue([
                'channelThumbnailSupportedRenderers',
                'channelThumbnailWithLinkRenderer',
                'thumbnail',
                'thumbnails'
              ]) ??
              [])
          .map<Thumbnail>(Thumbnail.fromMap)
          .toList(),
    );
  }
}

class DescriptionSnippet {
  final String text;
  final bool bold;

  DescriptionSnippet({required this.text, required this.bold});

  factory DescriptionSnippet.fromMap(map) {
    return DescriptionSnippet(
      text: map['text'] ?? "",
      bold: map['bold'] ?? false,
    );
  }
}
