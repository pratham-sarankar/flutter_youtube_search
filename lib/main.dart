import 'package:flutter_youtube_search/models/youtube_video.dart';
import 'package:flutter_youtube_search/youtube_search.dart';

void main() async {
  final firstPage = await YoutubeSearch().search(query: "Hello World");
  print((firstPage.contents.first as YoutubeVideo).title);
  final secondPage = await YoutubeSearch().next(firstPage.continuationKey!);
  print((secondPage.contents.first as YoutubeVideo).title);
  final thirdPage = await YoutubeSearch().next(secondPage.continuationKey!);
  print((thirdPage.contents.first as YoutubeVideo).title);
}
