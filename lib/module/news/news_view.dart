import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:url_launcher/url_launcher.dart';
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
          NewsListWidget(),
    );
  }
}

class NewsListWidget extends StatefulWidget {
  @override
  _NewsListWidgetState createState() => _NewsListWidgetState();
}

class _NewsListWidgetState extends State<NewsListWidget> {
  List<NewsItem> _fetchedNews = new List<NewsItem>();

  Widget build(BuildContext context) {
    List<Widget> newsWidgets = new List<Widget>();
    _fetchedNews.forEach((newsItem) {
      newsWidgets.add(ListTile(
        title: Row(
          children: <Widget>[
            FaIcon(FontAwesomeIcons.newspaper),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 20.0, top: 8.0, bottom: 8.0, right: 6.0),
                  child: Text(
                    newsItem.text,
                  ),
                )
            )
          ],
        ),
        onTap: () => newsItem.link != "" ? _launchURL(newsItem.link) : "",
      )
        ,);
    });
    if (newsWidgets.length > 0)
      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: ListView(
          children: newsWidgets,
        ),
      );
    else {
      return Center(
        child: Loading(
          indicator: BallPulseIndicator(), size: 100.0,color: Colors.pink,
        ),
      );
    }
  }

  void initState() {
    super.initState();
    fetchNewsArray().then((newsItemList) => updateBuild(newsItemList));
  }

  void updateBuild(newsItemList) {
    setState(() { _fetchedNews = newsItemList; });
  }

  // ignore: missing_return
  Future<List<NewsItem>> fetchNewsArray() async
  {
    print("Fetching the lastest news...");
    try
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
      }
    }
    catch(SocketException)
    {
      List<NewsItem> newsItemList = new List<NewsItem>();
      newsItemList.add(NewsItem(text: "Vous devez avoir internet pour charger les dernières nouvelles. Si vous êtes connecté·e et que vous voyez ce message, veuillez nous en informer via l'onglet \"Signaler un bug\". Ouvrez le menu à gauche pour continuer votre navigation."));
      return newsItemList;
    }
  }

  _launchURL(String url) async {
    await launch(url);
  }
}

class NewsItem {
  final String text;
  final String link;
  final String icon;

  NewsItem({this.text, this.link, this.icon});

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      text: json['text'],
      link: json['link'],
      icon: json['icon'],
    );
  }
}