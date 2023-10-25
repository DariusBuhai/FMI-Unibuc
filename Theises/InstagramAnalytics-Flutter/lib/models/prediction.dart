import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../utils/network.dart';

class PostDetails {
  String description;
  int meanLikes;
  DateTime postedOn;
  int faces, smiles, followers;
  Uint8List image;

  PostDetails(
      {this.description = "",
      this.meanLikes = 0,
      this.postedOn,
      this.followers = 0,
      this.faces = 0,
      this.smiles = 0,
      this.image}) {
    postedOn = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "mean_likes": meanLikes,
      "faces": faces,
      "smiles": smiles,
      "datetime": (postedOn.millisecondsSinceEpoch / 1000).floor(),
      "followers": followers,
    };
  }

  Future<dynamic> predictLikes() async {
    var response = await http.get(Uri.http(API_URI, "api/get/predict_likes",
        toJson().map((key, value) => MapEntry(key, value.toString()))));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return NetworkError();
  }

  Future<dynamic> addPostImage(ByteData newImage) async {
    var image64 = base64Encode(newImage.buffer.asUint8List());
    var response = await http.post(Uri.http(API_URI, "api/post/analyse_image"), body: image64);
    if(response.statusCode==200){
      var jsonResponse = jsonDecode(response.body);
      image = base64Decode(jsonResponse['image']).buffer.asUint8List();
      smiles = jsonResponse['features']['smiles'];
      faces = jsonResponse['features']['faces'];
      return true;
    }
    return NetworkError(response: response);
  }
}
