import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waha/data/colors.dart';
import 'package:waha/widget/appbar.dart';
import 'package:waha/widget/drawer.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

// final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();

class PeriodicTablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    final gridList = rootBundle.loadString('assets/elementsGrid.json')
        .then((source) => jsonDecode(source)['elements'] as List)
        .then((list) => list.map((json) => json != null ? ElementData.fromJson(json) : null).toList());

    return Scaffold(
        // key: _scaffoldKey,
      appBar: CustomAppBar("Tableau périodique", true),
      drawer: AppDrawer(),
        body: FutureBuilder(
          future: gridList,
          builder: (_, snapshot) => snapshot.hasData ? _buildTable(snapshot.data, context)
              : Center(child: CircularProgressIndicator()),
        ),
    );
  }

  Widget _buildTable(List<ElementData> elements, BuildContext context) {
    final tiles = elements.map((element) => element != null ? ElementTile(element)
        : Container(margin: kGutterInset, decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.all(Radius.circular(3.0)),),)).toList();

    return Center(
      child: SingleChildScrollView(
        child: SizedBox(height: kRowCount * (kContentSize + (kGutterWidth * 2)),
          child: GridView.count(crossAxisCount: kRowCount, children: tiles,
            scrollDirection: Axis.horizontal,),),),
    );
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
      ListTile(leading: Icon(Icons.category), title : Text(element.category), subtitle: Text('Catégorie'),),
      ListTile(leading: Icon(Icons.fiber_smart_record), title: Text(element.atomicWeight),
        subtitle: Text('Masse atomique'),),
      ListTile(leading: Icon(Icons.info), title : Text(element.extract),
        subtitle: Text(element.source,),),
    ].expand((widget) => [widget, Divider()]).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,

      appBar: AppBar(
        bottom: ElementTile(element, isLarge: true),
      ),

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
      Text(element.symbol, style: TextStyle(fontSize: 23.0, color: Colors.white)),
      Text(element.name, maxLines: 1, overflow: TextOverflow.ellipsis,
        textScaleFactor: isLarge ? 0.65 : 1, style: TextStyle(color: Colors.white)),
    ];
    final tile = Container(
      margin: kGutterInset,
      width: kContentSize,
      height: kContentSize,
      decoration: BoxDecoration(
        color: element.colors.first,
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
        boxShadow: isLarge ? [BoxShadow(color: Color.lerp(Colors.black, Colors.transparent, .7), blurRadius: 12.0)] : [],
      ),
      child: RawMaterialButton(
        onPressed: !isLarge ? () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => DetailPage(element))) : null,
        padding: kGutterInset * 2.0,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: tileText),
      ),
    );

    return Hero(
      tag: 'hero-${element.symbol}',
      flightShuttleBuilder: (_, anim, __, ___, ____) =>
          ScaleTransition(scale: anim.drive(Tween(begin: 1, end: 1.75)), child: tile),
      child: Transform.translate(offset: isLarge && kIsWeb ? Offset(0.0, -(kContentSize-22.5)) : Offset.zero, child: Transform.scale(scale: isLarge ? 1.75 : 1, child: tile)),
    );
  }
}
