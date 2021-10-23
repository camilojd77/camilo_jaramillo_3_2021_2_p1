import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:anime_app/components/loader_component.dart';
import 'package:anime_app/helpers/api_helper.dart';
import 'package:anime_app/models/anime.dart';
import 'package:anime_app/models/response.dart';
import 'package:anime_app/screens/anime_info_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class AnimesScreen extends StatefulWidget {
  @override
  _AnimesScreenState createState() => _AnimesScreenState();
}

class _AnimesScreenState extends State<AnimesScreen> {
  List<Anime> _animes = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _getAnimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animes'),
        actions: <Widget>[
          _isFiltered
              ? IconButton(
                  onPressed: _removeFilter, icon: Icon(Icons.filter_none))
              : IconButton(onPressed: _showFilter, icon: Icon(Icons.filter_alt))
        ],
      ),
      body: Center(
        child: _getContent(),
      ),
    );
  }

  Future<Null> _getAnimes() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = await ApiHelper.getAnimes();

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
      _animes = response.result;
    });
  }

  Widget _getContent() {
    return _animes.length == 0 ? _noContent() : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFiltered
              ? 'No hay animes con ese criterio de búsqueda.'
              : 'No hay animes registrados.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getAnimes,
      child: ListView(
        children: _animes.map((e) {
          return Card(
            color: Colors.grey.shade100,
            child: InkWell(
              onTap: () => _goInfoAnime(e),
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            e.anime_img,
                            width: 50,
                          ),
                        ),
                        Text(
                          e.anime_name,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios),
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

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('Filtrar Animes'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Escriba las primeras letras del anime'),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: 'Criterio de búsqueda...',
                      labelText: 'Buscar',
                      suffixIcon: Icon(Icons.search)),
                  onChanged: (value) {
                    _search = value;
                  },
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')),
              TextButton(onPressed: () => _filter(), child: Text('Filtrar')),
            ],
          );
        });
  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getAnimes();
  }

  void _filter() {
    if (_search.isEmpty) {
      return;
    }

    List<Anime> filteredList = [];
    for (var anime in _animes) {
      if (anime.anime_name.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(anime);
      }
    }

    setState(() {
      _animes = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  void _goInfoAnime(Anime anime) async {
    String? result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AnimeInfoScreen(anime: anime)));
    if (result == 'yes') {
      _getAnimes();
    }
  }
}
