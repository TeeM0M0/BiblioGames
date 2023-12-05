import 'package:bibliogame/class/gameInfo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<GameInfoClass>> gameInfo(List<GameInfoClass> games, int id) async {
  String Url =
      'http://api.rawg.io/api/games/$id?key=6191fd434aa74de5a0f31356b70b824a';

  Map<String, String> header = {
    "Content-type": "application/json; charset=UTF-8",
    "Accept": 'application/json',
  };

  final _uri = Uri.parse(Url);

  final response = await http.get(_uri, headers: header);

  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    GameInfoClass game = GameInfoClass(
        responseBody["name"],
        responseBody["background_image"],
        responseBody["genres"],
        responseBody["developers"],
        responseBody["description"],
        responseBody["metacritic"],
        responseBody["parent_platforms"],
        responseBody["released"]);
    games.add(game);
  } else {
    // Récupérer l'erreur de chargement et l'afficher
    print("Error: ${response.statusCode} - ${response.reasonPhrase}");
  }
  return games;
}
