import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'news_item.dart';
import 'dart:convert';
import 'constants.dart';

class NewsData {
  NewsData(this.title, this.content, this.rating);
  final String title;
  final String content;
  final String rating;
}

class NewsRow extends StatefulWidget {
  NewsRow(String code, {Key key}): _code = code, super(key: key);

  final String _code;

  @override
  _NewsRowState createState() => _NewsRowState();
}

class _NewsRowState extends State < NewsRow > {

  List < NewsData > _news = [];

  @override
  initState() {
    super.initState();
    updateNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/3.5,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _news == null ? 0 :_news.length,
        itemBuilder: (BuildContext context, int index) {
          NewsData newsPiece = _news[index];
          return Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: NewsItem(
              title: newsPiece.title,
              content: newsPiece.content,
              rating: newsPiece.rating,
            ),
          );
        },
      ),
    );
  }

  void updateNewsData() {
    fetchChartDataX().then((newsData) {
      setState(() {
        _news = newsData;
      });
    });
  }

  Future < List < NewsData > > fetchChartDataX() async {
    final response = await http.get(BASE_IP_NEWS + widget._code);
    final decodedResponse = json.decode(response.body);

    List < NewsData > ret = [];
    for (var element in decodedResponse) {
      ret.add(new NewsData(
        element["title"] == null ? "" : element["title"].toString(),
        element["description"] == null ? "" : element["description"].toString(),
        element["Score"] == null ? "" : element["Score"].toStringAsFixed(3),
      ));
    }

    return ret;
  }
}

