import 'dart:convert';
import 'dart:typed_data';
import 'dart:core';
import 'package:instagram_analytics/utils/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;

User loggedUser;

class User extends ChangeNotifier {
  int id;
  String email;
  String username;
  String loginType;
  Uint8List image;
  String token;

  User({
    this.id,
    this.email,
    this.username,
    this.token,
    this.image,
    this.loginType = "email",
  });

  /// Builders
  User cloneFrom(User _newUser) {
    id = _newUser.id;
    email = _newUser.email;
    username = _newUser.username;
    token = _newUser.token;
    image = _newUser.image;
    loginType = _newUser.loginType;
    return this;
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": id,
      "email": email,
      "username": username,
    };
  }

  static User from(User _fromUser) {
    User _newUser = User();
    _newUser.cloneFrom(_fromUser);
    return _newUser;
  }

  static Future<User> parseFromJson(
      Map<String, dynamic> jsonData, String token) async {
    try {
      Uint8List image;
      try {
        if(jsonData['image_id']!=null){
          image = (await NetworkAssetBundle(
              Uri.http(API_URI, "api/get/auth/image", {"token": token}))
              .load(""))
              .buffer
              .asUint8List();
        }
      } catch (e) {
        print("Unable to load image");
      }
      return User(
        id: jsonData["user_id"],
        email: jsonData["email"],
        username: jsonData["username"],
        token: token,
        image: image,
        loginType: jsonData['login_type'],
      );
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// Auth
  Future<void> logOut() async {
    var optionsBox = Hive.box('auth');
    var loginType = optionsBox.get("login-type");
    switch (loginType) {
      case "apple":
        optionsBox.delete("user-identifier");
        break;
      case "facebook":
        var facebookAccessToken = await FacebookAuth.instance.accessToken;
        if (facebookAccessToken != null && !facebookAccessToken.isExpired) {
          await FacebookAuth.instance.logOut();
        }
        break;
    }
    await http.post(Uri.http(API_URI, "api/post/auth/logout"),
        body: jsonEncode({"token": token}));
    optionsBox.delete("token");
    optionsBox.delete("login-type");
    optionsBox.put('logged-in', false);
    loggedUser = null;
  }

  Future<void> delete() async {
    await http.post(Uri.http(API_URI, "api/post/auth/delete"),
        body: jsonEncode({"token": token}));
    await logOut();
  }

  static Future<bool> isLoggedIn(BuildContext context) async {
    try {
      var optionsBox = Hive.box('auth');
      var loggedIn = optionsBox.get("logged-in");
      if (!loggedIn) return false;
      var loginType = optionsBox.get("login-type");
      switch (loginType) {
        case "email":
          var authToken = optionsBox.get("token");
          if (authToken != null) {
            loggedUser = await User.getFromSessionToken(authToken);
            if (loggedUser != null) return true;
          }
          break;
        case "apple":
          var userIdentifier = optionsBox.get("user-identifier");
          var credentialState =
              await SignInWithApple.getCredentialState(userIdentifier);
          if (credentialState == CredentialState.authorized) {
            var authToken = optionsBox.get("token");
            if (authToken != null) {
              loggedUser = await User.getFromSessionToken(authToken);
              if (loggedUser != null) return true;
            }
          }
          break;
        case "facebook":
          var facebookAccessToken = await FacebookAuth.instance.accessToken;
          if (facebookAccessToken != null && !facebookAccessToken.isExpired) {
            return (await User.performFacebookAuth(context)) == true;
          }
          break;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<User> getFromSessionToken(String token) async {
    http.Response response = await http
        .get(Uri.http(API_URI, "api/get/auth/user", {"token": token}));
    if (response.statusCode != 200) return null;

    return User.parseFromJson(jsonDecode(response.body), token);
  }

  static Future<dynamic> performFacebookAuth(BuildContext context) async {
    String facebookToken;
    var facebookAccessToken = await FacebookAuth.instance.accessToken;
    if (facebookAccessToken != null && !facebookAccessToken.isExpired) {
      facebookToken = (await FacebookAuth.instance.accessToken).token;
    } else {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) return false;
      facebookToken = result.accessToken.token;
    }
    var response = await http.post(Uri.http(API_URI, "api/post/auth/facebook"),
        body: jsonEncode({
          "token": facebookToken,
          "platform": Platform.isIOS ? 'ios' : 'android',
        }));
    if (response.statusCode != 200) return NetworkError(response: response);
    var responseData = json.decode(response.body);
    loggedUser = await User.getFromSessionToken(responseData["token"]);
    if (loggedUser == null) return NetworkError(response: response);
    loggedUser.notifyListeners();

    /// Save login type in hive box
    var optionsBox = Hive.box('auth');
    optionsBox.put("login-type", "facebook");
    optionsBox.put("token", responseData["token"]);
    optionsBox.put('logged-in', true);
    return true;
  }

  static Future<dynamic> performAppleAuth(BuildContext context) async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    var recommendedUsername = "";
    if (credential.givenName != null) {
      recommendedUsername += credential.givenName;
    }
    if (credential.familyName != null) {
      recommendedUsername += " ${credential.familyName}";
    }
    if (recommendedUsername == "") recommendedUsername = credential.email;
    print(credential.identityToken);
    var response = await http.post(Uri.http(API_URI, "api/post/auth/apple"),
        body: jsonEncode({
          "token": credential.identityToken,
          "username": recommendedUsername,
          "platform": Platform.isIOS ? 'ios' : 'android',
        }));
    if (response.statusCode != 200) return NetworkError(response: response);
    var responseData = json.decode(response.body);
    loggedUser = await User.getFromSessionToken(responseData["token"]);
    if (loggedUser == null) return NetworkError(response: response);
    loggedUser.notifyListeners();

    /// Save credentials in Hive box
    var optionsBox = Hive.box('auth');
    optionsBox.put("user-identifier", credential.userIdentifier);
    optionsBox.put("login-type", "apple");
    optionsBox.put("token", responseData["token"]);
    optionsBox.put('logged-in', true);
    return true;
  }

  static Future<dynamic> performLogin(
      String username, String password, BuildContext context) async {
    var response = await http.post(Uri.http(API_URI, "api/post/auth/login"),
        body: jsonEncode({
          "username": username,
          "password": password,
          "platform": Platform.isIOS ? 'ios' : 'android',
        }));
    if (response.statusCode != 200) return NetworkError(response: response);
    var responseData = json.decode(response.body);
    loggedUser = await User.getFromSessionToken(responseData["token"]);
    if (loggedUser == null) return NetworkError(response: response);
    loggedUser.notifyListeners();

    /// Save token
    var optionsBox = Hive.box('auth');
    optionsBox.put("token", loggedUser.token);
    optionsBox.put("login-type", "email");
    optionsBox.put('logged-in', true);
    return true;
  }

  static Future<dynamic> performRegister(
      String name, String email, String password, BuildContext context) async {
    var response = await http.post(Uri.http(API_URI, "api/post/auth/register"),
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "platform": Platform.isIOS ? 'ios' : 'android',
        }));
    if (response.statusCode != 200) return NetworkError(response: response);
    return true;
  }

  Future<User> updateUserProfilePicture(ByteData newImage) async {
    var image64 = base64Encode(newImage.buffer.asUint8List());
    await http.post(
        Uri.http(API_URI, "/api/post/auth/image", {"token": token}),
        body: image64);
    image = newImage.buffer.asUint8List();
    notifyListeners();
    return this;
  }

  Future<dynamic> updateUserPassword(
      String oldPassword, String newPassword) async {
    var response = await http.put(
        Uri.http(API_URI, "/api/put/auth/update_password"),
        body: jsonEncode({
          "token": token,
          "old_password": oldPassword,
          "new_password": newPassword
        }));
    if (response.statusCode != 200) return NetworkError(response: response);
    return true;
  }

  static Future<dynamic> resetUserPassword(
      String email, String newPassword) async {
    var response = await http.put(
        Uri.http(API_URI, "/api/put/auth/reset_password"),
        body: jsonEncode({"email": email, "password": newPassword}));
    if (response.statusCode != 200) return NetworkError(response: response);
    return true;
  }

  Future<dynamic> updateUser() async {
    var response = await http.put(Uri.http(API_URI, "/api/put/user"),
        body: jsonEncode({"token": token, "user": toJson()}));
    if (response.statusCode != 200) return NetworkError(response: response);
    notifyListeners();
    return true;
  }

  Future reloadUser() async {
    User _newUser = await User.getFromSessionToken(token);
    cloneFrom(_newUser);
    notifyListeners();
  }
}
