import 'package:bolalucu_admin/page/dashboard_page.dart';
import 'package:bolalucu_admin/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = false;
  bool? isLogin = prefs.getBool("is_login");
  if (isLogin != null) {
    if (isLogin){
      isLoggedIn = true;
    }
  }
  runApp(MyApp(isLogin: isLoggedIn,));
}

class MyApp extends StatelessWidget {
  final bool? isLogin;
  MyApp({Key? key, this.isLogin}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (isLogin!) {
      return MaterialApp(
        title: 'Bolalucu League',
        debugShowCheckedModeBanner: false,
        home: DashboardPage(),
      );
    } else {
      return MaterialApp(
        title: 'Bolalucu League',
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      );
    }
  }
}
