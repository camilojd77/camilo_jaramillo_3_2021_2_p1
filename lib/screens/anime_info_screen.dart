import 'dart:html';
import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anime_app/components/loader_component.dart';
import 'package:anime_app/helpers/api_helper.dart';
import 'package:anime_app/models/anime.dart';
import 'package:anime_app/models/anime_datails.dart';
import 'package:anime_app/models/response.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class AnimeInfoScreen extends StatefulWidget {
  final Anime anime;

  AnimeInfoScreen({required this.anime});

  @override
  _AnimeInfoScreenState createState() => _AnimeInfoScreenState();
}

class _AnimeInfoScreenState extends State<AnimeInfoScreen> {
  bool _showLoader = false;
  List<AnimeDetails> _animeDetails = [];
  late Anime _anime;

  @override
  void initState() {
    super.initState();
    _anime = widget.anime;
    _getAnime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(_anime.anime_name),
      ),
      body: Center(
        child: _showLoader
            ? LoaderComponent(
                text: 'Por favor espere...',
              )
            : _getContent(),
      ),
    );
  }

  Widget _showAnimeInfo() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      color: Colors.lightGreenAccent,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(),
                child: CachedNetworkImage(
                  imageUrl: _anime.anime_img,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  height: 300,
                  width: 300,
                  alignment: Alignment.topCenter,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> _getAnime() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = await ApiHelper.getAnime(_anime.anime_name);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _animeDetails = response.result;
    });
  }

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showAnimeInfo(),
        Expanded(
          child: _animeDetails.length == 0 ? _noContent() : _getListView(),
        ),
      ],
    );
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getAnime,
      child: ListView(
        children: _animeDetails.map((e) {
          return Card(
            color: Colors.lightGreenAccent.shade700,
            child: InkWell(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.fact,
                          style: TextStyle(
                              fontSize: 25,
                              fontStyle: FontStyle.normal,
                              color: Colors.black87),
                        ),
                        Icon(Icons.bakery_dining_sharp, color: Colors.white)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          'El anime no tiene hechos registrados.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
