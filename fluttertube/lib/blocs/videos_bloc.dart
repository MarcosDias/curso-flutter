import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/api.dart';
import 'package:fluttertube/models/video.dart';

class VideosBloc implements BlocBase {

  ApiService api;

  List<Video> videos;

  final StreamController<List<Video>> _videosController = StreamController<List<Video>>();
  final StreamController<String> _searchController = StreamController<String>();

  Stream get outVideos => _videosController.stream;
  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = ApiService();
    _searchController.stream.listen(_search);
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

  void _search(String search) async {

    if (search != null) {
      this._videosController.sink.add([]);
      this.videos = await api.search(search);
    } else {
      this.videos += await api.nextPage();
    }

    this._videosController.sink.add(videos);
  }
}