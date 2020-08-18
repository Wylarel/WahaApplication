import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waha/data/colors.dart';
import 'package:waha/widget/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waha/widget/load.dart';


class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nouveautés"),
          backgroundColor: getPink(),
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
        child: Load(100),
      );
    }
    else {
      List<Widget> newsWidgets = new List<Widget>();
      _fetchedNews.forEach((newsItem) {
        newsWidgets.add(Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
            child: ListTile(
              leading: FaIcon(FontAwesomeIcons.newspaper),
              title: Text(newsItem.date),
              subtitle: Text(
                newsItem.text,
                textAlign: TextAlign.justify,
              ),
              onTap: () => newsItem.link != null ? _launchURL(newsItem.link) : null,
            ),
          ),
        ),);
      });
      return Padding(
        padding: EdgeInsets.all(8.0),
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
    CollectionReference idsRef = Firestore.instance.collection("news");
    Query query = idsRef.orderBy("sort_index", descending: true);

    query.getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        fetchedNews.add(new NewsItem(text: result.data["text"], link: result.data["link"], date: result.data["date"]));
      });
      setState(() {_fetchedNews = fetchedNews;});
    });
  }

  _launchURL(String url) async {
    await launch(url);
  }
}

class NewsItem {
  final String text;
  final String link;
  final String date;

  NewsItem({this.text, this.link, this.date});
}