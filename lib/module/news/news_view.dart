import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:waha/widget/drawer.dart';
import 'package:http/http.dart' as http;


class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nouveautés"),
          backgroundColor: Colors.pink,
        ),
        drawer: AppDrawer(),
        body:
          ListView(
            children: displayNewsArray()
        )
    );
  }

  List<Widget> displayNewsArray() {
    List<Widget> widgetArray = new List<Widget>();
    // TODO: Add all the news as widget in widgetArray here
    return widgetArray;
  }

  Future<List<NewsItem>> fetchNewsArray() async
  {
    final response = await http.get(
        'https://raw.githubusercontent.com/WahaDevs/HomeScreenNews/master/news.json');

    if (response.statusCode == 200) {
      Map<String, dynamic> docJson = json.decode(response.body);
      List<NewsItem> newsItemList = new List<NewsItem>();
      docJson["news"].forEach((value) {
        newsItemList.add(NewsItem.fromJson(value));
      });
      return newsItemList;
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class NewsItem {
  final String title;
  final String first_line;
  final String second_line;
  final String link;
  final String icon;

  NewsItem({this.title, this.first_line, this.second_line, this.link, this.icon});

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'],
      first_line: json['first_line'],
      second_line: json['second_line'],
      link: json['link'],
      icon: json['icon'],
    );
  }
}