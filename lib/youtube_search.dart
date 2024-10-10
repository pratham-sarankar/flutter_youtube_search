library flutter_youtube_search;

import 'dart:async';
import 'dart:convert';

import 'package:flutter_youtube_search/core/constants.dart';
import 'package:flutter_youtube_search/core/extensions/map_extension.dart';
import 'package:flutter_youtube_search/models/response/youtube_search_response.dart';
import 'package:flutter_youtube_search/models/youtube_video.dart';
import 'package:http/http.dart' as http;

import 'models/abstract/youtube_content.dart';

class YoutubeSearch {
  /// Get the raw data from the Youtube API.
  Future<Map<String, dynamic>> _getRawData({
    required String query,
    String? searchPreferences,
  }) async {
    var response = await http.post(
      Uri.parse(
        'https://www.youtube.com/youtubei/v1/search?key=AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8',
      ),
      body: json.encode({
        ...Constants.requestPayload,
        "query": query,
      }),
      headers: Constants.headers,
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded;
    } else {
      throw Exception('Could not make request');
    }
  }

  /// Filter the unwanted data from the raw data
  Map<String, dynamic> _filterData(
      Map<String, dynamic> data, List contentPath) {
    Map<String, dynamic> filteredData = {};
    filteredData['contents'] = data.getNestedValue(contentPath);
    return filteredData;
  }

  /// Extract the continuation key from the contents
  String? _extractContinuationKey(Map<String, dynamic> data) {
    List contents = data['contents'];
    String? continuationKey;
    for (Map<String, dynamic> content in contents) {
      if (content.containsKey('continuationItemRenderer')) {
        continuationKey = content.getNestedValue(Constants.continuationKeyPath);
      }
    }
    return continuationKey;
  }

  /// Parse the filtered data to get the search result
  List<YoutubeContent> _parse(Map<String, dynamic> filteredData) {
    final List<YoutubeContent> result = [];
    for (Map<String, dynamic> section in filteredData['contents']) {
      if (section.containsKey('itemSectionRenderer')) {
        for (Map<String, dynamic> content in section['itemSectionRenderer']
            ['contents']) {
          if (content.containsKey('videoRenderer')) {
            final video = YoutubeVideo.fromMap(content['videoRenderer']);
            result.add(video);
          }
        }
      }
    }
    return result;
  }

  /// Get the result of the search query with the search preference
  /// This function fetched the raw data, filters the unwanted part, parse it and return it.
  Future<YoutubeSearchResponse> search({
    required String query,
    String? searchPreferences,
  }) async {
    final data =
        await _getRawData(query: query, searchPreferences: searchPreferences);
    final filteredData = _filterData(data, Constants.contentPath);
    final contents = _parse(filteredData);

    /// Write last_response.json file
    /// TODO: Emit this part line in production
    // final file = File(
    //     '/Users/prathamsarankar/StudioProjects/flutter_youtube_search/lib/data/last_response.json');
    // await file.writeAsString(jsonEncode(filteredData), mode: FileMode.write);

    // Get the continuation key from the contents
    final continuationKey = _extractContinuationKey(filteredData);
    return YoutubeSearchResponse(
      continuationKey: continuationKey,
      contents: contents,
    );
  }

  /// Get the next page of the search result
  Future<YoutubeSearchResponse> next(String continuationKey) async {
    final response = await http.post(
      Uri.parse('https://www.youtube.com/youtubei/v1/search'),
      body: json.encode({
        ...Constants.requestPayload,
        "continuation": continuationKey,
      }),
      headers: Constants.headers,
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final filteredData =
          _filterData(decoded, Constants.continuationContentPath);
      final contents = _parse(filteredData);
      // Get the continuation key from the contents
      final continuationKey = _extractContinuationKey(filteredData);
      return YoutubeSearchResponse(
        continuationKey: continuationKey,
        contents: contents,
      );
    } else {
      throw Exception('Could not make request');
    }
  }
}
