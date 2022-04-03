import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './model/places_model.dart';
import 'dart:convert';

class MainScreen extends StatefulWidget {
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  String apiKey = 'AIzaSyCHNh9kFkn42Gys8nBCuTJruYkIofgG9Dg';
  List<dynamic> _places = [];
  String latitude = '';
  String longitude = '';

  void findPlaceAutoCompleteSearch(String inputText) async {
    String urlAutoCompleteSearch =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$apiKey&components=country:IND";
    var responseAutoCompleteSearch =
        await http.get(Uri.parse(urlAutoCompleteSearch));
    var response = json.decode(responseAutoCompleteSearch.body);
    List<dynamic> placesPredictedList = response['predictions'];
    setState(() {
      _places = placesPredictedList;
    });
    print('Places Response ${_places[0]['description']}');
  }

  Future<void> selectPlace(String placeId) async {
    String searchPlaceUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";
    final selectPlaceResponse = await http.get(Uri.parse(searchPlaceUrl));
    var response = json.decode(selectPlaceResponse.body);
    print('Latitude ${response['result']['geometry']['location']['lat']}');
    print('Longitude ${response['result']['geometry']['location']['lng']}');
    setState(() {
      latitude = response['result']['geometry']['location']['lat'].toString();
      longitude = response['result']['geometry']['location']['lng'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //search place ui
          Container(
            height: 160,
            decoration: const BoxDecoration(
              color: Colors.black54,
              boxShadow: [
                BoxShadow(
                  color: Colors.white54,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(height: 25.0),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Search & Set DropOff Location",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.adjust_sharp,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (valueTyped) {
                              findPlaceAutoCompleteSearch(valueTyped);
                            },
                            decoration: const InputDecoration(
                              hintText: "search here...",
                              fillColor: Colors.white54,
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                left: 11.0,
                                top: 8.0,
                                bottom: 8.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 5),
              child: ListView.separated(
                  itemBuilder: (context, index) => InkWell(
                        onTap: () =>
                            selectPlace(_places[index]['place_id']).then((_) {
                          showDialog(
                              context: context,
                              builder: (context) => Container(
                                    height: 50,
                                    width: 200,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Text(latitude),
                                        Text(longitude)
                                      ],
                                    ),
                                  ));
                        }),
                        child: Text(
                          _places[index]['description'],
                          overflow: TextOverflow.visible,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                  separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        color: Colors.white,
                        thickness: 1,
                      ),
                  itemCount: _places.length),
            ),
          )

          //display place predictions result
          // (placesPredictedList.length > 0)
          //     ? Expanded(
          //         child: ListView.separated(
          //           itemCount: placesPredictedList.length,
          //           physics: ClampingScrollPhysics(),
          //           itemBuilder: (context, index)
          //           {
          //             return PlacePredictionTileDesign(
          //               predictedPlaces: placesPredictedList[index],
          //             );
          //           },
          //           separatorBuilder: (BuildContext context, int index)
          //           {
          //             return const Divider(
          //               height: 1,
          //               color: Colors.white,
          //               thickness: 1,
          //             );
          //           },
          //         ),
          //       )
          //     : Container(),
        ],
      ),
    );
  }
}
