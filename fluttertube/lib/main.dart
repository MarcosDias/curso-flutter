import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_blocs.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: VideosBloc(),
      child: BlocProvider(
        bloc: FavoriteBloc(),
        child: MaterialApp(
          title: 'FlutterTube',
          home: Home(),
        ),
      ),
    );
  }
}