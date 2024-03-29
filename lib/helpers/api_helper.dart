import 'dart:convert';
import 'package:anime_app/models/anime.dart';
import 'package:anime_app/models/anime_datails.dart';
import 'package:anime_app/models/response.dart';
import 'package:http/http.dart' as http;

import 'constans.dart';

class ApiHelper {
  static Future<Response> getAnimes() async {
    var url = Uri.parse('${Constans.apiUrl}');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json'
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Anime> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson['data']) {
        list.add(Anime.fromJson(item));
      }
    }

    return Response(isSuccess: true, result: list);
  }

  static Future<Response> getAnime(String anime_name) async {
    var url = Uri.parse('${Constans.apiUrl}/$anime_name');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json'
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<AnimeDetails> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson['data']) {
        list.add(AnimeDetails.fromJson(item));
      }
      /*for (var l in list) {
        print(l.fact);
      }*/
    }

    return Response(isSuccess: true, result: list);
  }
}
