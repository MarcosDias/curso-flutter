import 'dart:convert';

import 'package:fluttertube/models/video.dart';
import 'package:http/http.dart' as http;

import 'package:fluttertube/secret.dart';

const String API_KEY = API_KEY_SECRET;

class ApiService {

  String _search;
  String _nextToken;

  Future<List<Video>> search(String search) async {

    this._search = search;

    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
    );

    return decode(response);
  }

  Future<List<Video>> nextPage() async {
    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"
    );

    return decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);

      this._nextToken = decoded["nextPageToken"];

      List<Video> videos = decoded["items"].map<Video>((map)=> Video.fromJson(map)).toList();
      return videos;
    }

    throw Exception("Failed to load videos");
  }
}