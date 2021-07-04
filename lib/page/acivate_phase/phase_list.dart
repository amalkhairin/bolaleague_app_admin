import 'package:bolalucu_admin/constant/colors.dart';
import 'package:bolalucu_admin/page/acivate_phase/final/final_detail.dart';
import 'package:bolalucu_admin/page/acivate_phase/group_stage/group_list.dart';
import 'package:bolalucu_admin/page/acivate_phase/quarter_final/quarter_list_page.dart';
import 'package:bolalucu_admin/page/acivate_phase/round_stage/round_list_page.dart';
import 'package:bolalucu_admin/page/acivate_phase/semifinal/semifinal_list_page.dart';
import 'package:flutter/material.dart';

class PhaseListPage extends StatelessWidget {
  const PhaseListPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        title: Text("List of Phase", style: TextStyle(color: blackColor),),
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => GroupList())
                    );
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text("Group Stage"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RoundListPage())
                    );
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text("Round of 16"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => QuarterListPage())
                    );
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text("Quarter-Final"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SemifinalListPage())
                    );
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text("Semi-Final"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => FinalDetailPage())
                    );
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text("Final"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}