import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waha/widget/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waha/widget/load.dart';
import 'package:package_info/package_info.dart';


class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouveautés"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Ouvrir le menu',
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: AppVersionText(),
          )
        ],
      ),
      drawer: AppDrawer(),
      body:
      NewsListWidget(),
    );
  }
}

class AppVersionText extends StatefulWidget {
  @override
  _AppVersionTextState createState() => _AppVersionTextState();
}

class _AppVersionTextState extends State<AppVersionText> {
  String version = "";

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          version,
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
        )
    );
  }

  @override
  void initState() {
    super.initState();
    updateVersion();
  }

  void updateVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = "${packageInfo.version}+${packageInfo.buildNumber}";
    });
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
      newsWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {Scaffold.of(context).openDrawer();},
              textColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [FaIcon(FontAwesomeIcons.arrowLeft), Container(width: 14.0), Text("Ouvrir le menu", style: TextStyle(fontSize: 18.0))],),
            ),),
          )
      );
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
              onTap: () => newsItem.link != null ? _launchURL(newsItem.link) : {},
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
    CollectionReference idsRef = FirebaseFirestore.instance.collection("news");
    Query query = idsRef.orderBy("sort_index", descending: true);

    query.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        fetchedNews.add(new NewsItem(text: result.data()["text"], link: result.data()["link"], date: result.data()["date"]));
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