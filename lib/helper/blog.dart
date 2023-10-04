import 'dart:convert';
import 'dart:developer';

import '../models/article_model.dart';
import 'package:http/http.dart' as http;

class News {

  List<ArticleModel> news = [];

  Future<void> getBlog() async {
    String url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=d8eac98947f2438d9dcc3b407cbfb972";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    log(jsonData.toString());

    if (jsonData['status'] == "ok") {
      jsonData['articles'].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
              title: element['title'],
              author: element["author"] ?? "",
              description: element["description"],
              url: element["url"],
              urlToImage: element["urlToImage"],
              content: element["content"] ?? ""
          );

          news.add(articleModel);
        }
      });
    }
  }
}

class CategoryNewsClass {

  List<ArticleModel> news = [];

  Future<void> getNews(String category) async {
    String url = "https://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=0be6096aa54449e88da2f202525da8bd";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == "ok") {
      jsonData['articles'].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
              title: element['title'],
              author: element["author"] ?? "",
              description: element["description"],
              url: element["url"],
              urlToImage: element["urlToImage"],
              content: element["content"] ?? ""
          );

          news.add(articleModel);



        }
      });
    }
  }
}