import 'dart:convert';
import 'package:bolalucu_admin/config/api_route.dart';
import 'package:http/http.dart' as http;

class FinalHelper {
  static Future<dynamic> getFinalMatches() async {
    try {
      var url = Uri.https(API.URL, API.FINAL_MATCHES);
      print(url);
      var response = await http.get(url);
      print(response.body);
      var jsonRes = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonRes['success'] == true) {
          return {
            "success": true,
            "data": jsonRes['data'],
          };
        } else {
          return {
            "success": false,
            "message": jsonRes['message'],
          };
        }
      }
      return {
        "success": false,
        "message": "ERR: INVALID PARAMETER!",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "ERR: $e",
      };
    }
  }

  static Future<dynamic> updateFinalMatches(
      {String? matchID,
      String? homeTeamId,
      String? awayTeamId,
      String? homeScore,
      String? awayScore}) async {
    try {
      var url = Uri.https(API.URL, API.UPDATE_FINAL);
      print(url);
      var response = await http.put(url, body: {
        "match_id": matchID,
        "home_team_id": homeTeamId,
        "away_team_id": awayTeamId,
        "home_score": homeScore,
        "away_score": awayScore,
        "is_finished": "1",
      });
      print(response.body);
      var jsonRes = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonRes['success'] == true) {
          return {
            "success": true,
            "data": jsonRes['message'],
          };
        } else {
          return {
            "success": false,
            "message": jsonRes['message'],
          };
        }
      }
      return {
        "success": false,
        "message": jsonRes['message'],
      };
    } catch (e) {
      return {
        "success": false,
        "message": "ERR: $e",
      };
    }
  }

  static Future<dynamic> drawFinal() async {
    try {
      var url = Uri.https(API.URL, API.FINAL_DRAW);
      print(url);
      var response = await http.get(url);
      print(response.body);
      var jsonRes = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonRes['success'] == true) {
          return {
            "success": true,
            "data": jsonRes['data'],
          };
        } else {
          return {
            "success": false,
            "message": jsonRes['message'],
          };
        }
      }
      return {
        "success": false,
        "message": "ERR: INVALID PARAMETER!",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "ERR: $e",
      };
    }
  }
}
