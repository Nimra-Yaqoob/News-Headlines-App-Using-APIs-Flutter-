
import 'package:news_mobileapp/models/categories_news_model.dart';
import 'package:news_mobileapp/models/news_channel_headlines_modle.dart';
import 'package:news_mobileapp/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();
 Future<NewsChannelsHeadlinesModel> fetchNewChannelHeadlinesApi(String channelName) async{
    final response = await _rep.fetchNewChannelHeadlinesApi(channelName);
    return response ;
  }

   Future<CategoriesNewsModel>fetchCategoriesNewsApi(String category) async{
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response ;
  }
} 
