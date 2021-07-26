import 'package:bolalucu_admin/config/app_helper.dart';
import 'package:bolalucu_admin/config/group_helper.dart';
import 'package:bolalucu_admin/config/user_helper.dart';
import 'package:bolalucu_admin/constant/colors.dart';
import 'package:bolalucu_admin/page/acivate_phase/group_stage/group_detail.dart';
import 'package:flutter/material.dart';

class GroupList extends StatefulWidget {
  const GroupList({ Key? key }) : super(key: key);

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  List _groupName = ["A", "B", "C", "D", "E", "F", "G", "H"];
  bool _isLoading = false;
  bool _isError = false;
  bool? _isOpen = false;
  String _errMessage = "";
  List _teamList = [];

  loadTeamsData() async {
    setState(() {
      _isLoading = true;
    });
    var data = await UserHelper.getAllRegisteredTeamsDraw();
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

  Future<dynamic> checkPhase() async {
    setState(() {
      _isLoading = true;
    });
    var data = await AppHelper.isOpenPhase(phaseID: 1);
    if (data['success']) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = false;
          _isOpen = data['data'];
        });
      }
    } else {
      if (mounted) {
        setState(() {
          // _isLoading = false;
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
    checkPhase();
    loadTeamsData();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    if (_isLoading) {
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
      if(!_isError) {
        if (_isOpen!) {
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
              title: Text("Group Stage", style: TextStyle(color: blackColor),),
            ),
            body: SafeArea(
              child: Container(
                child: ListView.builder(
                  itemCount: _groupName.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => GroupStage(title: "${_groupName[index]}"))
                          );
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text("Group ${_groupName[index]}"),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        } else {
          if (_teamList.isEmpty && _isLoading) {
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
          } else if (_teamList.length < 32 && !_isLoading) {
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
                title: Text("Group Stage", style: TextStyle(color: blackColor),),
              ),
              body: SafeArea(
                child: Container(
                  child: Center(
                    child: Text("Ups! The team is not enough (${_teamList.length}/32)")
                  ),
                ),
              ),
            );
          } else {
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
                title: Text("Group Stage", style: TextStyle(color: blackColor),),
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    Container(
                      child: ListView.builder(
                        itemCount: 8,
                        itemBuilder: (context, index){
                          var idx = [];
                          if (index == 0){
                            idx = [0,1,2,3];
                          } else if (index == 1){
                            idx = [4,5,6,7];
                          } else if (index == 2){
                            idx = [8,9,10,11];
                          } else if (index == 3){
                            idx = [12,13,14,15];
                          } else if (index == 4){
                            idx = [16,17,18,19];
                          } else if (index == 5){
                            idx = [20,21,22,23];
                          } else if (index == 6){
                            idx = [24,25,26,27];
                          } else if (index == 7){
                            idx = [28,29,30,31];
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
                                child: Text("Group ${_groupName[index]}"),
                              ),
                              Padding(
                                padding: index == 7? EdgeInsets.fromLTRB(24, 24, 24, 100) : EdgeInsets.all(24),
                                child: Container(
                                  width: screenSize.width,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: DataTable(
                                    columns: [
                                      DataColumn(label: Text("Owner ID")),
                                      DataColumn(label: Text("Team Name")),
                                    ],
                                    rows: List.generate(4, (i) => DataRow(cells: [
                                      DataCell(Text("${_teamList[idx[i]]['owner_id']}")),
                                      DataCell(Text("${_teamList[idx[i]]['team_name']}"))
                                    ]))
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: 64,
                          child: ElevatedButton(
                            onPressed: (){
                              showDialog(
                                context: this.context, 
                                builder: (context) => AlertDialog(
                                  content: Text("Are you sure? this action cannot be undone"),
                                  actions: [
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        var data = await UserHelper.updatePhase(idPhase: "1", isOpen: "1");
                                        var data2;
                                        var pot = [];
                                        pot.add(_teamList.sublist(0,4));
                                        pot.add(_teamList.sublist(4,8));
                                        pot.add(_teamList.sublist(8,12));
                                        pot.add(_teamList.sublist(12,16));
                                        pot.add(_teamList.sublist(16,20));
                                        pot.add(_teamList.sublist(20,24));
                                        pot.add(_teamList.sublist(24,28));
                                        pot.add(_teamList.sublist(28,32));
                                        for (var i = 0; i < pot.length; i++) {
                                          data2 = await GroupHelper.addGroup(teamList: pot[i], groupName: _groupName[i]);
                                        }
                                        checkPhase();
                                        loadTeamsData();
                                      },
                                      child: Text("Ok"),
                                    ),
                                  ],
                                )
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: blueColor,
                              onPrimary: whiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(38)
                              )
                            ),
                            child: Text("Draw Group Stage"),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        }
      } else {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: Container(
              child: Center(
                child: Text("ERR: $_errMessage"),
              ),
            ),
          ),
        );
      }
    }
  }
}