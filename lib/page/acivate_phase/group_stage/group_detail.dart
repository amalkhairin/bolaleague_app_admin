import 'dart:io';

import 'package:bolalucu_admin/config/group_helper.dart';
import 'package:bolalucu_admin/config/user_helper.dart';
import 'package:bolalucu_admin/constant/colors.dart';
import 'package:bolalucu_admin/model/match_model.dart';
import 'package:bolalucu_admin/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupStage extends StatefulWidget {
  final String? title;
  const GroupStage({ Key? key, this.title }) : super(key: key);

  @override
  _GroupStageState createState() => _GroupStageState();
}

class _GroupStageState extends State<GroupStage> {
  List<int> _matchDay = [1,2,3,4,5,6];
  int? _selectedMatchIndex;
  TextDetector _textDetector = GoogleMlKit.vision.textDetector();
  var _inputImage;
  File? _image;
  final _picker = ImagePicker();
  User _user = User.instance;
  bool _isLoading = false;
  bool _isError = false;
  String _errMessage = "";
  List _groupStandings = [];
  List<MatchModel> _listMatches = []; 

  isUserGroup(){
    bool isExist = false;
    for (Map<String,dynamic> data in _groupStandings) {
      if (data['owner_id'] == _user.ownerId){
        isExist = true;
        break;
      }
    }
    return isExist;
  }

  isUserMatch(int matchday) {
    bool isExist = false;
    for (MatchModel data in _listMatches) {
      if(matchday == data.matchDay){
        if (data.homeTeamID == _user.ownerId || data.awayTeamID == _user.ownerId) {
          isExist = true;
          break;
        }
      }
    }
    return isExist;
  }

  getMatchOfDay(int matchday) {
    List<MatchModel> _temp = [];
    for (MatchModel data in _listMatches) {
      if(matchday == data.matchDay){
        _temp.add(data);
      }
    }
    return _temp;
  }

  isValidMatchdayImage(String homeName, String awayName, List<String> result){
    bool isHomeExist = false;
    bool isAwayExist = false;
    for (String item in result) {
      if(item.contains(homeName)){
        isHomeExist = true;
      }
      if(item.contains(awayName)){
        isAwayExist = true;
      }
    }
    if (isHomeExist == true && isAwayExist == true){
      return true;
    } else {
      return false;
    }
  }

  loadGroupData() async {
    setState(() {
      _isLoading = true;
    });
    List<MatchModel> _temp = [];
    var data = await GroupHelper.getGroupStanding(groupName: widget.title);
    var data2 = await GroupHelper.getGroupMatches(groupName: widget.title);
    if (data['success'] && data2['success']) {
      for (Map<String, dynamic> match in data2['data']) {
        _temp.add(MatchModel.fromJson(match));
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = false;
          _groupStandings = data['data'];
          _listMatches = _temp;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = true;
          _errMessage = data['message'] + "&" + data2['message'];
        });
      }
    }
  }

  getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
        _inputImage = InputImage.fromFile(_image!);
      } else {
        print("No image selected");
      }
    });
  }

  languageDetector(String text){
    if (text.contains("Next") || text.contains("Back"))
      return "EN";
    else if (text.contains("Kembali") || text.contains("Berikut"))
      return "ID";
    else
      return "ERR";
  }

  extractText(String text){
    List<String> _temp = text.split("\n");
    return _temp;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadGroupData();
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
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: backgroundColor,
            leading: IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back, color: blackColor,),
            ),
            title: Text("Group Stage", style: TextStyle(color: blackColor),),
            actions: [
              TextButton(
                onPressed: () async {
                  loadGroupData();
                },
                child: Text("Refresh"),
              )
            ],
          ),
          body: SafeArea(
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 14),
                    child: Text("Group ${widget.title!}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                    child: Container(
                      width: screenSize.width,
                      // height: 200,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          dividerThickness: 1,
                          columns: [
                            DataColumn(label: Text("No")),
                            DataColumn(label: Text("Team")),
                            DataColumn(label: Text("P")),
                            DataColumn(label: Text("M")),
                            DataColumn(label: Text("M")),
                            DataColumn(label: Text("S")),
                            DataColumn(label: Text("K")),
                            DataColumn(label: Text("GM")),
                            DataColumn(label: Text("GK")),
                            DataColumn(label: Text("+/-")),
                          ],
                          rows: List.generate(4, (i) {
                            return DataRow(
                              cells: [
                                DataCell(Text("${i+1}")),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        String msg = "Halo bro, kita berdua masih punya jadwal pertandingan. jadi kita bisa main kapan?";
                                        var url = "whatsapp://send?phone=${_groupStandings[i]['no_wa']}&text=$msg";
                                        launch(url);
                                      },
                                      icon: Icon(Icons.chat,color: blueColor,)
                                    ),
                                    Text("${_groupStandings[i]['team_name']}"),
                                  ],
                                )),
                                DataCell(Text("${_groupStandings[i]['poin']}")),
                                DataCell(Text("${_groupStandings[i]['main']}")),
                                DataCell(Text("${_groupStandings[i]['menang']}")),
                                DataCell(Text("${_groupStandings[i]['seri']}")),
                                DataCell(Text("${_groupStandings[i]['kalah']}")),
                                DataCell(Text("${_groupStandings[i]['gm']}")),
                                DataCell(Text("${_groupStandings[i]['gk']}")),
                                DataCell(Text("${_groupStandings[i]['jumlah']}")),
                              ]
                            );
                          })
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 14),
                    child: Text("Recent Match", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 14),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      itemBuilder:(context, matchIndex) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Matchday ${matchIndex+1}"),
                          SizedBox(height: 14,),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 2,
                            itemBuilder: (context, cardIndex){
                              List<MatchModel> _temp = getMatchOfDay(matchIndex+1);
                              return Padding(
                                padding: EdgeInsets.only(bottom: 14),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _temp[cardIndex].isFinished != 1
                                    ? ExpansionTile(
                                      collapsedBackgroundColor: Color(0xFFFBFBFB),
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              CircleAvatar(backgroundColor: Colors.blue, child: Text("${_temp[cardIndex].homeTeamName!.substring(0,1)}"),),
                                              Container(
                                                width: 80,
                                                child: Center(child: Text("${_temp[cardIndex].homeTeamName}", overflow: TextOverflow.ellipsis,))
                                              ),
                                            ],
                                          ),
                                          Text("${_temp[cardIndex].homeScore} - ${_temp[cardIndex].awayScore}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                                          Column(
                                            children: [
                                              CircleAvatar(backgroundColor: Colors.orange, child: Text("${_temp[cardIndex].awayTeamName!.substring(0,1)}"),),
                                              Container(
                                                width: 80,
                                                child: Center(child: Text("${_temp[cardIndex].awayTeamName}", overflow: TextOverflow.ellipsis,))
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(24),
                                              child: InkWell(
                                                onTap: () async {
                                                  await getImage();
                                                },
                                                child: Container(
                                                  height: 180,
                                                  width: screenSize.width,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  child: _image == null
                                                      ? Center(child: Text("Upload Image"))
                                                      : Image.file(_image!)
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                                              child: SizedBox(
                                                width: screenSize.width,
                                                child: ElevatedButton(
                                                  onPressed: () async{
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    RecognisedText recognisedText = await _textDetector.processImage(_inputImage);
                                                    List<String> _tmp = extractText(recognisedText.text);
                                                    
                                                    bool isValid = isValidMatchdayImage(_temp[cardIndex].homeTeamName!, _temp[cardIndex].awayTeamName!, _tmp);
                                                     
                                                    if (isValid) {
                                                      String homeTeam = "";
                                                      for (String item in _tmp) {
                                                        if (item == _temp[cardIndex].homeTeamName!){
                                                          homeTeam = item;
                                                          break;
                                                        }
                                                        if (item == _temp[cardIndex].awayTeamName!){
                                                          homeTeam = item;
                                                          break;
                                                        }
                                                      }
                                                      var data = Map<String, dynamic>();
                                                      if (homeTeam == _temp[cardIndex].homeTeamName!) {
                                                        var home = _tmp[2];
                                                        var away = _tmp[3];
                                                         
                                                        data = await GroupHelper.updateGroupMatches(
                                                          groupName: widget.title,
                                                          matchID: "${_temp[cardIndex].matchID}",
                                                          homeTeamId: "${_temp[cardIndex].homeTeamID}",
                                                          awayTeamId: "${_temp[cardIndex].awayTeamID}",
                                                          homeScore: home,
                                                          awayScore: away,
                                                        );
                                                      } else if (homeTeam == _temp[cardIndex].awayTeamName!){
                                                        var home = _tmp[3];
                                                        var away = _tmp[2];
                                                         
                                                        data = await GroupHelper.updateGroupMatches(
                                                          groupName: widget.title,
                                                          matchID: "${_temp[cardIndex].matchID}",
                                                          homeTeamId: "${_temp[cardIndex].homeTeamID}",
                                                          awayTeamId: "${_temp[cardIndex].awayTeamID}",
                                                          homeScore: home,
                                                          awayScore: away,
                                                        );
                                                      } else {
                                                        data['success'] = false;
                                                        data['message'] = "Invalid match result";
                                                      }
                                                      if (data['success']) {
                                                        loadGroupData();
                                                        setState(() {
                                                          _image = null;
                                                          _inputImage = null;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          _image = null;
                                                          _inputImage = null;
                                                          _isLoading = false;
                                                        });
                                                        showDialog(
                                                          context: this.context, 
                                                          builder: (context) => AlertDialog(
                                                            title: Text("ERR"),
                                                            content: Text("${data['message']}"),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: (){
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Text("Ok"),
                                                              ),
                                                            ],
                                                          )
                                                        );
                                                      }
                                                    } else {
                                                      setState(() {
                                                        _isLoading = false;
                                                        _image = null;
                                                        _inputImage = null;
                                                      });
                                                      showDialog(
                                                        context: this.context, 
                                                        builder: (BuildContext context) => AlertDialog(
                                                          title: Text("ERR"),
                                                          content: Text("Invalid match result"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: (){
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text("Ok"),
                                                            ),
                                                          ],
                                                        )
                                                      );
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    primary: blueColor,
                                                    elevation: 0.0,
                                                  ),
                                                  child: Text("Save"),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                    : Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            CircleAvatar(backgroundColor: Colors.blue, child: Text("${_temp[cardIndex].homeTeamName!.substring(0,1)}"),),
                                            Container(
                                                width: 80,
                                                child: Center(child: Text("${_temp[cardIndex].homeTeamName}", overflow: TextOverflow.ellipsis,))
                                              ),
                                          ],
                                        ),
                                        Text("${_temp[cardIndex].homeScore} - ${_temp[cardIndex].awayScore}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                                        Column(
                                          children: [
                                            CircleAvatar(backgroundColor: Colors.orange, child: Text("${_temp[cardIndex].awayTeamName!.substring(0,1)}"),),
                                            Container(
                                                width: 80,
                                                child: Center(child: Text("${_temp[cardIndex].awayTeamName}", overflow: TextOverflow.ellipsis,))
                                              ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
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