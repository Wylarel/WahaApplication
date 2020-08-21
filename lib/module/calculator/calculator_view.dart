import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:waha/widget/appbar.dart';
import 'package:waha/widget/drawer.dart';
import 'package:intl/intl.dart';


class CalculatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Calculatrice", true),
        drawer: AppDrawer(),
        body: SimpleCalculator(
          numberFormat: NumberFormat.decimalPattern("fr_BE"),
          theme: const CalculatorThemeData(
          ),
        )
    );
  }
}