import 'dart:convert';
import 'package:bolalucu_admin/config/api_route.dart';
import 'package:http/http.dart' as http;

class GroupHelper {
  static Future<dynamic> getGroupStanding({String? groupName}) async {
    try {
      var url = Uri.https(API.URL, API.STANDING + "/$groupName");
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
        "message": "ERR: INVALID PARAMETER",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "ERR: $e",
      };
    }
  }

  static Future<dynamic> getGroupMatches({String? groupName}) async {
    try {
      var url = Uri.https(API.URL, API.GROUP_MATCH + "/$groupName");
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

  static Future<dynamic> updateGroupMatches({String? groupName, String? matchID, String? homeTeamId, String? awayTeamId, String? homeScore, String? awayScore}) async {
    try {
      int score1 = int.parse(homeScore!);
      int score2 = int.parse(awayScore!);
      String result = "draw";
      if (score1 > score2) {
        result = "home_win";
      } else if (score2 > score1) {
        result = "away_win";
      }
      var url = Uri.https(API.URL, API.UPDATE_GROUP + "/$groupName");
      print(url);
      var response = await http.put(url, body: {
        "match_id": matchID,
        "home_team_id": homeTeamId,
        "away_team_id": awayTeamId,
        "home_score": homeScore,
        "away_score": awayScore,
        "is_finished": "1",
        "match_result": result,
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

  static Future<dynamic> addGroup({List? teamList, String? groupName}) async {
    try {
      var url = Uri.https(API.URL, API.ADD_GROUP + "/$groupName");
      print(url);
      List<Map<String, dynamic>> _temp = [];
      for (var i = 0; i < teamList!.length; i++) {
        _temp.add({
          "owner_id" : teamList[i]['owner_id'].toString(),
          "team_name" : teamList[i]['team_name'],
          "no_wa": teamList[i]['no_wa']
        });
      }
      var reqBody = {
        "team_list" : _temp,
      };
      var body = json.encode(reqBody);
      print(body);
      var response = await http.post(url, body: body, headers: {'Content-type': 'application/json'});
      print(response.body);
      var jsonRes = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonRes['success'] == true) {
          return {
            "success": true,
            "message": jsonRes['message'],
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
        "message": jsonRes['message'],
      };
    } catch (e) {
      return {
        "success": false,
        "message": "ERR: $e",
      };
    }
  }

  static Future<dynamic> drawRound() async {
    try {
      var url = Uri.https(API.URL, API.GROUP_QUALIFIED);
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