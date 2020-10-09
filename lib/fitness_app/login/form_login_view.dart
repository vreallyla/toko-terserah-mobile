

import 'package:best_flutter_ui_templates/event/animation/spinner.dart';
import 'package:best_flutter_ui_templates/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FormLoginView extends StatefulWidget {
  @override
  _FormLoginViewState createState() => _FormLoginViewState();
}

class _FormLoginViewState extends State<FormLoginView> {
  TextEditingController emailInput = new TextEditingController();
  TextEditingController passwordInput = new TextEditingController();
  Widget buttonSubmit;
  LoginModel loginModel;
  var isLoading = false;
  

  @override
  // void initState() {}

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    List<Widget> listViews = <Widget>[];
    

    listViews.add(Container(
      height: 245 + sizeu.width / 10,
      padding: EdgeInsets.fromLTRB(
          sizeu.width / 10, sizeu.width / 10, sizeu.width / 10, 15),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Email' ,
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold))),
          SizedBox(
            width: sizeu.width - sizeu.width / 5,
            height: 40,
            child: TextField(
              controller: emailInput,
              textAlign: TextAlign.left,
              onChanged: (text) => {setState(() {})},
              decoration: new InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38, width: 1),
                ),
                hintText: 'Masukkan Email',
              ),
            ),
          ),
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 10, top: 10),
              child: Text('Password' ,
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold))),
          SizedBox(
            width: sizeu.width - sizeu.width / 5,
            height: 40,
            child: TextField(
              controller: passwordInput,
              obscureText: true,
              textAlign: TextAlign.left,
              onChanged: (text) => {setState(() {})},
              decoration: new InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38, width: 1),
                ),
                hintText: 'Masukkan Password',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top:5),
            child: Text((loginModel != null ? loginModel.data : ''),style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500, fontSize: 13),),
          ),
          Container(
              margin: EdgeInsets.only(top: 15),
              width: sizeu.width - sizeu.width / 5,
              height: 40,
              child: RaisedButton(
                onPressed: () {
                  // changeButton(); 
                  passwordInput.text = 'secret';
                  emailInput.text = 'fiqy_a@icloud.com';
                  isLoading=true;
                  loginModel=null;
                  setState(() {});
                  LoginModel.loginManual(
                          (emailInput.text != null ? emailInput.text : ''),
                          (passwordInput.text != null
                              ? passwordInput.text
                              : ''))
                      .then((value) {
                    // emailInput.text = value.error.toString();
                    if(!value.error){
                      // Navigator.pop(context,jsonEncode({"load":true}));
                      Navigator.of(context)
    .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false,arguments: {"after_login":true});
                      
                    }else{
                      loginModel = value;
                      
                    }
                    isLoading=false;
                      setState(() {});
                    
                  });
                },
                color: Colors.green,
                child: (!isLoading
                    ? Text(
                        'Masuk',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )
                    : Spinner(
                        icon: FontAwesomeIcons.spinner, color: Colors.white)),
              )),
        ],
      ),
    ));

    if (isLoading) {
      listViews.add(Container(
        height: sizeu.height,
        width: sizeu.width,
        color: Colors.black.withOpacity(0.4),
      ));
    }

    return Stack(
      children: listViews,
    );
  }
}
