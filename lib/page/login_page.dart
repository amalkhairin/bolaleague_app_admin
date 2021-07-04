import 'package:bolalucu_admin/config/user_helper.dart';
import 'package:bolalucu_admin/constant/colors.dart';
import 'package:bolalucu_admin/model/user_model.dart';
import 'package:bolalucu_admin/page/dashboard_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSecure = true;
  bool _isLoading = false;
  TextEditingController _ownerIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 100,
                    child: Image.asset("assets/img/logo.png"),
                  ),
                  SizedBox(height: 24,),
                  TextFormField(
                    controller: _ownerIdController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "Enter your Username",
                      filled: true,
                      fillColor: whiteColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isSecure,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      filled: true,
                      fillColor: whiteColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      suffixIcon: InkWell(
                        onTap: (){
                          setState(() {
                            _isSecure = !_isSecure;
                          });
                        },
                        child: _isSecure? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                      ),
                    ),
                  ),
                  SizedBox(height: 64,),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: blueColor,
                        onPrimary: whiteColor
                      ),
                      onPressed: _isLoading? (){} : (_ownerIdController.text.isEmpty || _passwordController.text.isEmpty)? null : () async {
                        if (_ownerIdController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                          setState(() {
                            _isLoading = true;
                          });
                          var data = await UserHelper.logInAdmin(
                            username: _ownerIdController.text,
                            password: _passwordController.text
                          );
                          if(data['success']){
                            setState(() {
                              _isLoading = false;
                            });
                            if(data['data'][0]['status'] == 0){
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("${data['message']}"),
                                  content: Text("Please contact Admin to complete the registration"),
                                  actions: [
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Ok"),
                                    )
                                  ],
                                )
                              );
                            } else {
                              User user = User(data);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => DashboardPage())
                              );
                            }
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Login failed!"),
                                content: Text("${data['message']}"),
                                actions: [
                                  TextButton(
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Ok"),
                                  )
                                ],
                              )
                            );
                          }
                        }
                      },
                      child: _isLoading? CircularProgressIndicator(color: whiteColor,) : Text("Login"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}