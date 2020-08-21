import 'package:flutter/material.dart';
import 'package:waha/data/colors.dart';
import 'package:waha/widget/appbar.dart';
import 'package:waha/widget/drawer.dart';
import 'package:waha/widget/load.dart';


class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Horaire", true),
      drawer: AppDrawer(),
      body: ScheduleGrid(),
    );
  }
}

class ScheduleGrid extends StatefulWidget {
  @override
  _ScheduleGridState createState() => _ScheduleGridState();
}

class _ScheduleGridState extends State<ScheduleGrid> {
  var dataTable = List.generate(7, (i) => List(5), growable: false);

  bool loaded;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetTable = [Padding( padding: const EdgeInsets.symmetric(horizontal: 30.0), child: FlatButton( color: Theme.of(context).primaryColor, textColor: Colors.white, onPressed: () { print("Button pressed"); }, child: Text("Les horaires ne sont pas encore disponnibles"), ), ),];

    for (var hour in dataTable) {
      List<Expanded> rowWidgetTable = new List<Expanded>();
      for (var day in hour) {
        rowWidgetTable.add(
            Expanded(child:Padding(padding: const EdgeInsets.all(3.0),child: Container(decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5)),child: Align( alignment: Alignment.center, child:Text(day!=null?day:"", textAlign: TextAlign.center))),
            ))
        );
      }
      widgetTable.add(
          Expanded(child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.stretch, children: rowWidgetTable))
      );
    }

    return !loaded ? Center(child: Load(100)) : Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widgetTable,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    updateTable();
  }

  void updateTable() async {
    setState(() {loaded = true;});
  }
}