import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:page_transition/page_transition.dart';
import 'package:waha/widget/appbar.dart';
import 'package:waha/widget/drawer.dart';
import 'package:waha/widget/load.dart';
import 'scraper.dart' as scraper;

class DictionaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Dictionnaire", true),
        drawer: AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
          child: DictionaryContent(),
        ),
    );
  }
}

class DictionaryContent extends StatefulWidget {
  @override
  _DictionaryContentState createState() => _DictionaryContentState();
}

class _DictionaryContentState extends State<DictionaryContent> {
  final TextEditingController searchFieldController = new TextEditingController();
  List<scraper.Definition> queryResults = [];
  bool waiting = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> queryResultsAsTiles = [Container(height: 12,)];
    queryResults.forEach((scraper.Definition def) {queryResultsAsTiles.add(
        new ListTile(
          title: Text(def.word),
          subtitle: Text(def.snippet, maxLines: 2, overflow: TextOverflow.ellipsis,),
          onTap: (){scraper.getContentFromDefinition(def).then(
                  (content) => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child:
                  DictionaryViewPage(data: content, word: def.word)))
            );},
        )
    );});
    queryResultsAsTiles.add(Container(height: 12,));

    return Column(
      children: [
        TextField(
          controller: searchFieldController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (String query){getAndSetResult(query);},
        ),
        Expanded(
          child: queryResults.length != 0 ?
          ListView(children: queryResultsAsTiles) :
          Center(child: waiting ? Load(100) : Text("Veuillez faire une recherche pour commencer")),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    //getAndSetResult("ACAB"); //TODO: Remove this debug line
  }

  void getAndSetResult(String query) async {
    setState(() {waiting = true; queryResults = [];});
    List<scraper.Definition> queryResult = await scraper.scrapWord(query, context);
    setState(() {
      queryResults = queryResult;
      waiting = false;
    });
  }
}

class DictionaryViewPage extends StatefulWidget {
  final String data;
  final String word;

  DictionaryViewPage({this.data, this.word});

  @override
  _DictionaryViewPageState createState() => _DictionaryViewPageState(data: data, word: word);
}

class _DictionaryViewPageState extends State<DictionaryViewPage> {
  final String data;
  final String word;

  _DictionaryViewPageState({this.data, this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dictionnaire: $word"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: DictionaryPage()));
              },
              tooltip: 'Revenir en arrière',
            );
          },
        ),
      ),
      drawer: AppDrawer(),
      body:  ListView(
        children: [Html(
          data: data,
          onLinkTap: (url) {
            print(url);
          },
        ),]
      )
    );
  }
}