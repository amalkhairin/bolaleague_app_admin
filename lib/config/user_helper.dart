import 'dart:convert';
import 'package:bolalucu_admin/config/api_route.dart';
import 'package:http/http.dart' as http;

class UserHelper {
  static Future<dynamic> logIn({String? ownerId, String? password}) async {
    try {
      var url = Uri.https(API.URL, API.LOGIN);
       
      var response = await http.post(url, body: {
        "owner_id": ownerId,
        "password": password,
      });
       
      var jsonRes = json.decode(response.body);
      if(response.statusCode == 200) {
        if(jsonRes['success'] == true){
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

  static Future<dynamic> logInAdmin({String? username, String? password}) async {
    try {
      var url = Uri.https(API.URL, API.LOGIN_ADMIN);
       
      var response = await http.post(url, body: {
        "username": username,
        "password": password,
      });
       
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

  static Future<dynamic> signUp({String? ownerId, String? teamName, String? noWa, String? password}) async {
    try {
      var url = Uri.https(API.URL, API.SIGN_UP);
       
      var response = await http.post(url, body: {
        "owner_id": ownerId,
        "team_name": teamName,
        "no_wa": noWa,
        "password": password,
        "status": "0",
      });
       
      var jsonRes = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
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
        "message": jsonRes['message'],
      };
    } catch (e) {
      return {
        "success": false,
        "message": "ERR: $e",
      };
    }
  }

  static Future<dynamic> getAllRegisteredTeams() async {
    try {
      var url = Uri.https(API.URL, API.REGISTERED_TEAMS);
       
      var response = await http.get(url);
       
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
        "message": jsonRes['message'],
      };
    } catch (e) {
      return {
        "success": false,
        "message": "ERR: $e",
      };
    }
  }

  static Future<dynamic> getAllTeams() async {
    try {
      var url = Uri.https(API.URL, API.USER);
       
      var response = await http.get(url);
       
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
        "message": jsonRes['message'],
      };
    } catch (e) {
      return {
        "success": false,
        "message": "ERR: $e",
      };
    }
  }

  static Future<dynamic> getTeamById({String? ownerId}) async {
    try {
      var url = Uri.https(API.URL, API.USER + "/$ownerId");
       
      var response = await http.get(url);
       
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
        "message": jsonRes['message'],
      };
    } catch (e) {
      return {
        "success": false,
        "message": "ERR: $e",
      };
    }
  }

  static Future<dynamic> getTeamWANumber({String? ownerId}) async {
    try {
      var url = Uri.https(API.URL, API.NO_WA + "/$ownerId");
       
      var response = await http.get(url);
       
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
        "message": jsonRes['message'],
      };
    } catch (e) {
      return {
        "success": false,
        "message": "ERR: $e",
      };
    }
  }

  static Future<dynamic> updateStatus({String? ownerId, String? newStatus}) async {
    try {
      var url = Uri.https(API.URL, API.UPDATE_STATUS);
       
      var response = await http.put(url, body: {
        "owner_id": ownerId,
        "status": newStatus,
      });
       
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

  static Future<dynamic> updatePhase({String? idPhase, String? isOpen}) async {
    try {
      var url = Uri.https(API.URL, API.UPDATE_PHASE);
       
      var response = await http.put(url, body: {
        "id_phase": idPhase,
        "is_open": isOpen,
      });
       
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
}