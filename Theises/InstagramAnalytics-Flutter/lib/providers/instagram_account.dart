import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_analytics/providers/user.dart';

import '../utils/network.dart';

class InstagramAccount extends ChangeNotifier {
  int followers, following, postsCount, uid;
  int medianLikes;
  String username;
  bool connected = false;

  InstagramAccount(
      {this.followers = 0,
      this.following = 0,
      this.medianLikes = 0,
      this.postsCount = 0,
      this.uid = 0,
      this.username});

  void fromJson(Map<String, dynamic> jsonData) {
    followers = jsonData['followers'];
    following = jsonData['following'];
    medianLikes = jsonData['median_likes'];
    postsCount = jsonData['posts_count'];
    uid = jsonData['uid'];
    username = jsonData['username'];
  }

  Future<dynamic> loadUser() async {
    if(loggedUser==null) return;
    var response = await http.get(Uri.http(API_URI, "api/get/instagram_user",
        {"token": loggedUser.token, "username": username}));
    if (response.statusCode == 200) {
      fromJson(jsonDecode(response.body));
      notifyListeners();
      connected = true;
      return true;
    } else {
      return NetworkError(response: response);
    }
  }
}
