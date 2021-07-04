import 'package:bolalucu_admin/config/app_helper.dart';
import 'package:bolalucu_admin/config/user_helper.dart';
import 'package:bolalucu_admin/constant/colors.dart';
import 'package:bolalucu_admin/page/acivate_phase/phase_list.dart';
import 'package:bolalucu_admin/page/edit_message/edit_message_page.dart';
import 'package:bolalucu_admin/page/list_of_teams/list_of_teams.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({ Key? key }) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  child: Image.asset("assets/img/logo.png", fit: BoxFit.fitWidth,),
                ),
                SizedBox(height: 24,),
                Container(
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Dashboard - Admin')
                  ),
                ),
                SizedBox(height: 42,),
                Expanded(
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ListOfTeamsPage())
                          );
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.list_alt_rounded, size: 72, color: blueColor,),
                              SizedBox(height: 14,),
                              Text("List of teams", style: TextStyle(fontSize: 18),)
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => PhaseListPage())
                          );
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.toggle_on_outlined, size: 72, color: blueColor,),
                              SizedBox(height: 14,),
                              Text("Activate Phase", style: TextStyle(fontSize: 18),)
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => EditMessagePage())
                          );
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.message_outlined, size: 72, color: blueColor,),
                              SizedBox(height: 14,),
                              Text("Edit Message", style: TextStyle(fontSize: 18),)
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _isLoading? (){} : () async {
                          showDialog(
                            context: this.context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Warning!"),
                                content: Text("Are you sure? all data will be deleted"),
                                actions: [
                                  TextButton(
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      var data = await AppHelper.resetSeason();
                                      var data2 = await UserHelper.updatePhase(idPhase: "1", isOpen: "0");
                                      var data3 = await UserHelper.updatePhase(idPhase: "2", isOpen: "0");
                                      var data4 = await UserHelper.updatePhase(idPhase: "3", isOpen: "0");
                                      var data5 = await UserHelper.updatePhase(idPhase: "4", isOpen: "0");
                                      var data6 = await UserHelper.updatePhase(idPhase: "5", isOpen: "0");
                                      if (data['success']) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text("Reset Successfully")));
                                      } else {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ERR: ${data['message']}")));
                                      }
                                    },
                                    child: Text("Ok"),
                                  )
                                ],
                              );
                            }
                          );
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _isLoading? CircularProgressIndicator() : Icon(Icons.restart_alt_outlined, size: 72, color: blueColor,),
                              SizedBox(height: 14,),
                              Text("Reset Season", style: TextStyle(fontSize: 18),)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}