import 'package:flutter/material.dart';
import 'stock_chart.dart';
import 'news_row.dart';
import 'tweet_row.dart';
import 'final_chart.dart';
import 'headline_prediction.dart';

class CompanyDetails extends StatelessWidget {

  CompanyDetails(this._companyName, this._companyCode, {Key key}): super(key: key);

  final String _companyName, _companyCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_companyName),
        backgroundColor: Colors.black87,
      ),
      body: ListView(
        children: < Widget > [
          Column(
            children: < Widget > [
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "     Stock Prices",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.0),
              Container(
                child: StockChart(_companyCode),
                // graph with time x price of stock
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Column(
            children: < Widget > [
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "     Stock Influence",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.0),
              Container(
                child: FinalChart(_companyName, _companyCode),
                // graph with news influence x price of stock
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "     Relevant Tweets",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          TweetRow(_companyCode), // show analyzed tweets
          SizedBox(height: 10.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "     Relevant news",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          NewsRow(_companyName), // show analyzed news
          SizedBox(height: 10.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "     Tweet impact prediction",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          HeadlinePrediction(_companyName, _companyCode), 
          // show prediction box where you can input a fake tweet and see how
          // it would affect the stock market
        ],
      ),
    );
  }
}
