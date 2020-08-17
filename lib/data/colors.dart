import 'package:flutter/material.dart';

Map<int, Color> color =
{
   50:Color.fromRGBO(251,0,133, .1),
  100:Color.fromRGBO(251,0,133, .2),
  200:Color.fromRGBO(251,0,133, .3),
  300:Color.fromRGBO(251,0,133, .4),
  400:Color.fromRGBO(251,0,133, .5),
  500:Color.fromRGBO(251,0,133, .6),
  600:Color.fromRGBO(251,0,133, .7),
  700:Color.fromRGBO(251,0,133, .8),
  800:Color.fromRGBO(251,0,133, .9),
  900:Color.fromRGBO(251,0,133, 1),
};

MaterialColor pink = MaterialColor(0xFFFB0085, color);

MaterialColor getPink() {return pink;}