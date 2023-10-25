import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'tweet.dart';
import 'dart:convert';
import 'constants.dart';

class TweetData {
  TweetData(this.content, this.shares, this.rating, this.likes, this.stocPrice);
  final String content;
  final String shares;
  final String rating;
  final String stocPrice;
  final String likes;
}

class TweetRow extends StatefulWidget {
  TweetRow(String code, {Key key}): _code = code, super(key: key);

  final String _code;

  @override
  _TweetRowState createState() => _TweetRowState();
}

class _TweetRowState extends State < TweetRow > {

  List < TweetData > _tweets = [];

  @override
  initState() {
    super.initState();
    updateTweetData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3.5,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _tweets == null ? 0 :_tweets.length,
        itemBuilder: (BuildContext context, int index) {
          TweetData newsPiece = _tweets[index];
          return Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Tweet(
              content: newsPiece.content,
              shares: newsPiece.shares,
              rating: newsPiece.rating,
              stocPrice: newsPiece.stocPrice,
              likes: newsPiece.likes,
            ),
          );
        },
      ),
    );
  }

  void updateTweetData() {
    fetchChartDataX().then((tweetData) {
      setState(() {
        _tweets = tweetData;
      });
    });
  }

  Future < List < TweetData > > fetchChartDataX() async {
    final response = await http.get(BASE_IP_TWEETS + widget._code);
    final decodedResponse = json.decode(response.body);

    List < TweetData > ret = [];
    for (var element in decodedResponse) {
      ret.add(new TweetData(
        element["text"] == null ? "" : element["text"].toString(),
        element["shares"] == null ? "" : element["shares"].toString(),
        element["Score"] == null ? "" : element["Score"].toStringAsFixed(3),
        element["likes"] == null ? "" : element["likes"].toStringAsFixed(0),
        element["stoc_price"] == null ? "" : element["stoc_price"].toString(),
      ));
    }

    return ret;
  }
}

