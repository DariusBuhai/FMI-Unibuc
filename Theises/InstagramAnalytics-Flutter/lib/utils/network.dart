import 'package:instagram_analytics/components/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

const String API_URI = "176.126.237.70:3002";
const String FULL_API_URI = "http://$API_URI";

class NetworkResponse{
  int statusCode;
  dynamic response;
  String title = "";
  String message = "";

  NetworkResponse(this.response);

  void showAlert(BuildContext context){}
}

class NetworkSuccess extends NetworkResponse{
  NetworkSuccess({http.Response response}) : super(response);

  @override
  void showAlert(BuildContext context){
    alertDialog(context, title: "Request success");
  }
}

class NetworkError extends NetworkResponse{

  NetworkError({http.Response response}) : super(response){
    statusCode = response.statusCode;
    try{
      var jsonData = jsonDecode(response.body);
      title = jsonData["title"] ?? "";
      message = jsonData["message"] ?? "";
    }catch(e){
      title = "Undefined error";
      message = "An undefined error has occurred";
    }
  }

  @override
  void showAlert(BuildContext context){
    alertDialog(context, title: title, subtitle: message);
  }

}