import 'package:bibliogame/class/games.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Games>> listGames(List<Games> games, int page) async {
  String baseUrl =
      'http://api.rawg.io/api/games?key=6191fd434aa74de5a0f31356b70b824a';
  String queryParams = '&page=${page}&platforms=4';

  String fullUrl = '$baseUrl$queryParams';

  Map<String, String> header = {
    "Content-type": "application/json; charset=UTF-8",
    "Accept": 'application/json',
  };

  final _uri = Uri.parse(fullUrl);

  final response = await http.get(_uri, headers: header);

  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (responseBody.containsKey('results')) {
      List<dynamic> gamesList = responseBody['results'];
      for (int i = 0; i < gamesList.length; i++) {
        Games mess = Games(gamesList[i]["id"],gamesList[i]["name"], gamesList[i]["background_image"]);
        games.add(mess);
      }
      print("Chargement terminé !");
    } else {
      print(
          "La structure de la réponse JSON ne correspond pas à ce qui était prévu.");
    }
  } else {
    // Récupérer l'erreur de chargement et l'afficher
    print("Error: ${response.statusCode} - ${response.reasonPhrase}");
  }
  return games;
}
