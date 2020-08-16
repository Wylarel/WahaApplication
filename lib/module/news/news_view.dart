import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waha/widget/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';


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
    if (_fetchedNews == null || _fetchedNews.length == 0) {
      return Center(
        child: Loading(
          indicator: BallPulseIndicator(), size: 100.0, color: Colors.pink,
        ),
      );
    }
    else {
      List<Widget> newsWidgets = new List<Widget>();
      newsWidgets.add(Divider());
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
                      textAlign: TextAlign.justify,
                    ),
                  )
              )
            ],
          ),
          onTap: () => newsItem.link != null ? _launchURL(newsItem.link) : null,
        ),);
        newsWidgets.add(Divider());
      });
      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: ListView(
          children: newsWidgets,
        ),
      );
    }
  }

  void initState() {
    super.initState();
    fetchNewsArray();
  }

  void fetchNewsArray() async
  {
    print("Fetching the lastest news...");

    List<NewsItem> fetchedNews = new List<NewsItem>();
    Firestore.instance.collection("news").getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        fetchedNews.add(new NewsItem(text: result.data["text"], link: result.data["link"]));
        setState(() {_fetchedNews = fetchedNews;});
      });
    });
  }

  _launchURL(String url) async {
    await launch(url);
  }
}

class NewsItem {
  final String text;
  final String link;

  NewsItem({this.text, this.link});
}