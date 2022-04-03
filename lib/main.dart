import 'package:flutter/material.dart';
import './mainScreen.dart';

void main() => runApp(SearchPlacesScreen());

class SearchPlacesScreen extends StatefulWidget {
  SearchPlacesScreenState createState() => SearchPlacesScreenState();
}

class SearchPlacesScreenState extends State<SearchPlacesScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.red), home: MainScreen());
  }
}
