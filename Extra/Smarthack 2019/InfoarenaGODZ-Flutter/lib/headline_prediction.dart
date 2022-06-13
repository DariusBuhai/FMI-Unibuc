import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

class HeadlinePrediction extends StatefulWidget {
  HeadlinePrediction(String name, String code, {Key key}):
    _name = name, _code = code, super(key: key);

  final String _name, _code;

  @override
  _HeadlinePredictionState createState() => _HeadlinePredictionState();
}

class _HeadlinePredictionState extends State < HeadlinePrediction > {

  String _headline = "";
  String _likes = "0";
  String _shares = "0";
  String _prediction = "0";
  // prediction parameters

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Card(
        elevation: 2.0,
        color: Colors.white,
        child: Column(
          children: < Widget > [
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: < Widget > [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Stock impact:",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "$_prediction %",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        color: (_prediction[0] == '-' ? Colors.red : Colors.lightGreen),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  labelText: "Headline",
                  hintText: "Enter a headlien",
                ),
                onChanged: (value) {
                  _headline = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  labelText: "Nr. of Likes",
                  hintText: "Enter an Integer",
                ),
                onChanged: (value) {
                  _likes = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  labelText: "Nr. of Shares",
                  hintText: "Enter an Integer",
                ),
                onChanged: (value) {
                  _shares = value;
                },
              ),
            ),
            FlatButton(
              child: Text("Predict"),
              onPressed: () {
                requestPrediction().then((prediction) {
                  setState(() {
                    _prediction = prediction;
                    print(prediction);
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future < String > requestPrediction() async {

    final String link = BASE_IP_HEADLINE + _headline + "/" +
      _likes + "/" + _shares + "/" + widget._name + "/" +
      widget._code;

    final response = await http.get(link);
    final decodedResponse = json.decode(response.body);

    return decodedResponse.toStringAsFixed(1);
  }
}
