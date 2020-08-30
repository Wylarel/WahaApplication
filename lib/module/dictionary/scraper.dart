import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

Future<List<Definition>> scrapWord(String wordToScrap, BuildContext context) async {
  String url = 'https://fr.wiktionary.org/w/api.php?action=query&list=search&srsearch=$wordToScrap&format=json';
  http.Response response;
  try {
    response = await http.get(url);
  } catch(KeyError) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Votre appareil ne semble pas être compatible avec le dictionnaire',
      desc: 'Cette partie de l\'app est encore en construction, réessayez plus tard !',
      btnCancelText: "Ok",
      btnCancelOnPress: () {},
    )..show();
    response = await http.get(url);
  }
  if(response.statusCode != 200) {
    return([Definition(statusCode: response.statusCode)]);
  }
  var jsonResult = json.decode(response.body);
  var queryResults = jsonResult["query"]["search"];
  List<Definition> defs = new List<Definition>();
  queryResults.forEach((dynamic queryResult) {
    defs.add(Definition(
      statusCode: response.statusCode, word: queryResult["title"], snippet: _parseHtmlString(queryResult["snippet"]), pageid: queryResult["pageid"]
    ));
  });
  return(defs);
}

Future<String> getContentFromDefinition(Definition definition) async {
  String url = await getUrlFromDefinition(definition);
  http.Response response = await http.get(url);
  if(response.statusCode != 200) {
    return("Veuillez réessayer plus tard");
  }
  return parse(response.body).getElementsByClassName("mw-parser-output")[0].innerHtml.replaceAll("//upload", "https://upload");
}

Future<String> getUrlFromDefinition(Definition definition) async {
  String url = 'https://fr.wiktionary.org/w/api.php?action=query&prop=info&inprop=url&pageids=${definition.pageid}&format=json';
  http.Response response = await http.get(url);
  if(response.statusCode != 200) {
    return("https://fr.wiktionary.org/wiki/erreur_404");
  }
  var jsonResult = json.decode(response.body);
  return jsonResult["query"]["pages"][definition.pageid.toString()]["fullurl"];
}

class Definition {
  final int statusCode;
  final String word;
  final String snippet;
  final String definition;
  final int pageid;

  Definition({this.statusCode, this.word, this.snippet, this.definition, this.pageid});
}

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);
  String parsedString = parse(document.body.text).documentElement.text;
  return parsedString;
}
