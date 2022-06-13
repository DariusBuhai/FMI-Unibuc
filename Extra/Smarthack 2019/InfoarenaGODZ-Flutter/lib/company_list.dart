import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'constants.dart';
import 'company_details.dart';

class Company {
  Company(this._name, this._code, this._avgStock, this._lastStock);
  final String _name;
  final String _code;
  final String _avgStock;
  final String _lastStock;
} // holds details about about one company

class CompanyList extends StatefulWidget {
  CompanyList({Key key}): super(key: key);

  @override
  _CompanyListState createState() => _CompanyListState();
}

class _CompanyListState extends State < CompanyList > {

  List < Company > _companies = [];

  @override 
  initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (Timer t) => _updateCompanyList());
    // init and refresh company list every 3 seconds
  }

  @override 
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: _companies.length * 2,
        itemBuilder: (BuildContext context, int index) {

          if ((index & 1) == 1) return Divider(
            height: 5.0,
          );

          int divIndex = (index / 2).floor();
          var currentComp = _companies[divIndex];
          double priceEvolution = double.parse(_companies[divIndex]._lastStock) - 
              double.parse(_companies[divIndex]._avgStock);
          // difference between average price and last price of stock

          return ListTile(
            title: Container(
              margin: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: < Widget > [
                  Row(
                    children: < Widget > [
                      Icon(
                        (priceEvolution >= 0 ? Icons.arrow_upward : Icons.arrow_downward),
                        color: (priceEvolution >= 0 ? Colors.green : Colors.red),
                        // negative means downtrend, positive means uptrend
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          currentComp._name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                      ), // displacy company name
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "\$ ${currentComp._lastStock}",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0,
                        color: Colors.black87
                      ),
                    ),
                  ), // display last price of stock
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CompanyDetails(currentComp._name, currentComp._code);
                  }
                ),
              ); // when tapped just to new windows to see more details
            },
          );
        }
      ),
      color: Colors.white,
    );
  }

  void _updateCompanyList() {
    fetchCompanyData().then((companies) {
      setState(() {
        _companies = companies; 
        // update company list
      });
    });
  }

  Future < List < Company > > fetchCompanyData() async {
    final response = await http.get(BASE_IP_COMPANIES);
    final decodedResponse = json.decode(response.body);

    List < Company > ret = [];
    for (var element in decodedResponse) {
      ret.add(Company(
        element["name"].toString(),
        element["code"].toString(),
        element["medium_stock"].toString(),
        element["last_stock"].toString(),
      ));
    }

    // fetch and parse company data from database
    return ret;
  }
}
