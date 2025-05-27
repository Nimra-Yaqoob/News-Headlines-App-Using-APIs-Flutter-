import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_mobileapp/models/categories_news_model.dart';
import 'package:news_mobileapp/models/news_channel_headlines_modle.dart';

class NewsRepository {
  Future<NewsChannelsHeadlinesModel> fetchNewChannelHeadlinesApi(
    String channelName,
  ) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=$channelName&apiKey=4fcf9ba5bb9e41e4aba9d36409d20eb3';
    if (kDebugMode) {
      print(url);
    }
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(
    String category,
  ) async {
    String url =
        'https://newsapi.org/v2/everything?q=${category}&apiKey=4fcf9ba5bb9e41e4aba9d36409d20eb3';
    if (kDebugMode) {
      print(url);
    }
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }
}
