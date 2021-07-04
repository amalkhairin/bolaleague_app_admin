import 'package:bolalucu_admin/config/app_helper.dart';
import 'package:bolalucu_admin/constant/colors.dart';
import 'package:flutter/material.dart';

class EditMessagePage extends StatefulWidget {
  const EditMessagePage({ Key? key }) : super(key: key);

  @override
  _EditMessagePageState createState() => _EditMessagePageState();
}

class _EditMessagePageState extends State<EditMessagePage> {
  TextEditingController _textEditingController = TextEditingController();
  bool _isLoading = true;
  bool _isError = false;
  String _errMessage = "";
  String message = "Loading...";

  getMessage() async {
    setState(() {
      _isLoading = true;
    });
    var data = await AppHelper.getMessage();
    if(data['success']){
      if(mounted){
        setState(() {
          _isLoading = false;
          _isError = false;
          message = data['data'][0]['message'];
          _textEditingController.text = message;
        });
      }
    } else {
      if(mounted){
        setState(() {
          _isLoading = false;
          _isError = true;
          message = "ERR: ${data['message']}";
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessage();
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
            title: Text("Edit Message", style: TextStyle(color: blackColor),),
          ),
          body: SafeArea(
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                      child: Text("Enter your message"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: TextFormField(
                        controller: _textEditingController,
                        autofocus: true,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: "Enter your message",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            var data = await AppHelper.updateMessage(message: _textEditingController.text);
                            if(data['success']){
                              setState(() {
                                _isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Message updated!")));
                              getMessage();
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ERR: ${data['message']}")));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: blueColor,
                            onPrimary: whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(38)
                            )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Text("Save"),
                          ),
                        ),
                      ),
                    )
                  ],
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