import 'package:bolalucu_admin/config/user_helper.dart';
import 'package:bolalucu_admin/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ListOfTeamsPage extends StatefulWidget {
  const ListOfTeamsPage({ Key? key }) : super(key: key);

  @override
  _ListOfTeamsPageState createState() => _ListOfTeamsPageState();
}

class _ListOfTeamsPageState extends State<ListOfTeamsPage> {
  bool _isLoading = true;
  bool _isError = false;
  String _errMessage = "";
  List _teamList = [];

  bool setBoolean(int x){
    if (x == 1) 
      return true ;
    else 
      return false; 
  }

  loadTeamsData() async {
    setState(() {
      _isLoading = true;
    });
    var data = await UserHelper.getAllTeams();
    if (data['success']) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = false;
          _teamList = data['data'];
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = true;
          _errMessage = data['message'];
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTeamsData();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    
    if(_isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: CircularProgressIndicator(color: whiteColor,),
              )
            ),
          ),
        ),
      );
    } else {
      if (!_isError) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: backgroundColor,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: blackColor,
              ),
            ),
            title: Text("List of Teams", style: TextStyle(color: blackColor),),
            actions: [
              TextButton(
                onPressed: () async {
                  loadTeamsData();
                },
                child: Text("Refresh"),
              )
            ],
          ),
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10)
              ),
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("No.")),
                        DataColumn(label: Text("Status")),
                        DataColumn(label: Text("Owner ID")),
                        DataColumn(label: Text("Team Name")),
                        DataColumn(label: Text("No. WA")),
                        DataColumn(label: Text("Action")),
                      ],
                      rows: List.generate(_teamList.length, (index) {
                        return DataRow(cells: [
                          DataCell(Text("${index+1}")),
                          DataCell(Switch(
                            value: setBoolean(_teamList[index]['status']),
                            onChanged: (value) async {
                              setState(() {
                                _isLoading = true;
                              });
                              var status = 0;
                              if (_teamList[index]['status'] == 1){
                                status = 0;
                              } else {
                                status = 1;
                              }
                              var data = await UserHelper.updateStatus(ownerId: "${_teamList[index]['owner_id']}", newStatus: status.toString());
                              if(data['success']){
                                loadTeamsData();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update success")));
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ERR: ${data['message']}")));
                              }
                            },
                          )),
                          DataCell(SelectableText("${_teamList[index]['owner_id']}")),
                          DataCell(SelectableText("${_teamList[index]['team_name']}")),
                          DataCell(SelectableText("${_teamList[index]['no_wa']}")),
                          DataCell(
                            IconButton(
                              onPressed: () {
                                String msg = "Halo bro, kita berdua masih punya jadwal pertandingan. jadi kita bisa main kapan?";
                                var url = "whatsapp://send?phone=${_teamList[index]['no_wa']}&text=$msg";
                                launch(url);
                              },
                              icon: Icon(Icons.chat,color: blueColor,)
                            ),
                          ),
                        ]);
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: Center(
              child: Text("$_errMessage"),
            ),
          ),
        );
      }
    }
  }
}