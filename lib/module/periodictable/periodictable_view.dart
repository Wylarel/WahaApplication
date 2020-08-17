import 'package:flutter/material.dart';
import 'package:waha/data/colors.dart';
import 'package:waha/widget/drawer.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();

class PeriodicTablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    final gridList = rootBundle.loadString('assets/elementsGrid.json')
        .then((source) => jsonDecode(source)['elements'] as List)
        .then((list) => list.map((json) => json != null ? ElementData.fromJson(json) : null).toList());

    return Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: gridList,
          builder: (_, snapshot) => snapshot.hasData ? _buildTable(snapshot.data)
              : Center(child: CircularProgressIndicator()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
          child: Icon(Icons.menu),
          backgroundColor: getPink(),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }

  Widget _buildTable(List<ElementData> elements) {
    final tiles = elements.map((element) => element != null ? ElementTile(element)
        : Container(color: Colors.grey[200], margin: kGutterInset)).toList();

    return SingleChildScrollView(
      child: SizedBox(height: kRowCount * (kContentSize + (kGutterWidth * 2)),
        child: GridView.count(crossAxisCount: kRowCount, children: tiles,
          scrollDirection: Axis.horizontal,),),);
  }
}


const kRowCount = 10;

const kContentSize = 64.0;
const kGutterWidth = 2.0;

const kGutterInset = EdgeInsets.all(kGutterWidth);


class ElementData {

  final String name, category, symbol, extract, source, atomicWeight;
  final int number;
  final List<Color> colors;

  ElementData.fromJson(Map<String, dynamic> json)
      : name = json['name'], category = json['category'], symbol = json['symbol'],
        extract = json['extract'], source = json['source'],
        atomicWeight = json['atomic_weight'], number = json['number'],
        colors = (json['colors'] as List).map((value) => Color(value)).toList();
}

class DetailPage extends StatelessWidget {
  DetailPage(this.element);

  final ElementData element;

  @override
  Widget build(BuildContext context) {
    final listItems = <Widget>[
      ListTile(leading: Icon(Icons.category), title : Text(element.category.toUpperCase())),
      ListTile(leading: Icon(Icons.info), title : Text(element.extract),
        subtitle: Text(element.source),),
      ListTile(leading: Icon(Icons.fiber_smart_record), title: Text(element.atomicWeight),
        subtitle: Text('Masse atomique'),),
    ].expand((widget) => [widget, Divider()]).toList();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Color.lerp(getPink(), element.colors[1], 0),
        bottom: ElementTile(element, isLarge: true),),

      body: ListView(padding: EdgeInsets.only(top: 24.0), children: listItems),
    );
  }
}


class ElementTile extends StatelessWidget implements PreferredSizeWidget {
  const ElementTile(this.element, { this.isLarge = false });

  final ElementData element;
  final bool isLarge;

  Size get preferredSize => Size.fromHeight(kContentSize * 1.5);

  @override
  Widget build(BuildContext context) {
    final tileText = <Widget>[
      Align(alignment: AlignmentDirectional.centerStart,
        child: Text('${element.number}', style: TextStyle(fontSize: 10.0, color: Colors.white)),),
      Text(element.symbol, style: Theme.of(context).primaryTextTheme.headline5),
      Text(element.name, maxLines: 1, overflow: TextOverflow.ellipsis,
        textScaleFactor: isLarge ? 0.65 : 1, style: Theme.of(context).primaryTextTheme.bodyText1),
    ];
    final tile = Container(
      margin: kGutterInset,
      width: kContentSize,
      height: kContentSize,
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(colors: element.colors),
        backgroundBlendMode: BlendMode.plus,),
      child: RawMaterialButton(
        onPressed: !isLarge ? () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => DetailPage(element))) : null,
        fillColor: Colors.black,
        disabledElevation: 10.0,
        padding: kGutterInset * 2.0,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: tileText),
      ),
    );

    return Hero(
      tag: 'hero-${element.symbol}',
      flightShuttleBuilder: (_, anim, __, ___, ____) =>
          ScaleTransition(scale: anim.drive(Tween(begin: 1, end: 1.75)), child: tile),
      child: Transform.scale(scale: isLarge ? 1.75 : 1, child: tile),
    );
  }
}
