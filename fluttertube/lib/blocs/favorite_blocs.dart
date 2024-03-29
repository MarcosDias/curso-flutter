import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/models/video.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBloc implements BlocBase {

  Map<String, Video> _favorites = {};

  final _favController = BehaviorSubject<Map<String, Video>>(seedValue: {});

  Stream<Map<String, Video>> get outFav => this._favController.stream;

  FavoriteBloc() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getKeys().contains("favorites")) {
        this._favorites = json.decode(prefs.getString("favorites")).map(
                (key, value) => MapEntry(key, Video.fromJson(value))
        ).cast<String, Video>();
      }
      this._favController.add(this._favorites);
    });
  }

  void toggleFavorite(Video video) {
    if (_favorites.containsKey((video.id))) {
      _favorites.remove(video.id);
    } else {
      _favorites[video.id] = video;
    }

    _favController.sink.add(_favorites);

    _saveFav();
  }

  void _saveFav() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("favorites", json.encode(this._favorites));
    });
  }

  @override
  void dispose() {
    this._favController.close();
  }

}