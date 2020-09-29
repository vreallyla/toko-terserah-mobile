import 'package:best_flutter_ui_templates/event/animation/spinner.dart';
import 'package:best_flutter_ui_templates/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class formLoginView extends StatefulWidget {
  @override
  _formLoginViewState createState() => _formLoginViewState();
}

class _formLoginViewState extends State<formLoginView> {
  TextEditingController emailInput = new TextEditingController();
  TextEditingController passwordInput = new TextEditingController();
  Widget buttonSubmit;
  LoginModel loginModel = null;
  bool test = false;

  @override
  void initState() {
    changeButton();
  }

  void changeButton() {
    Widget childButton;

    if (!test) {
      childButton = Text(
        'Masuk',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      );
    } else {
      Spinner(icon: Icons.access_alarm);
    }
    buttonSubmit = RaisedButton(
      onPressed: () {
        // LoginModel.connectToAPI('tahu', 'tempe').then((value) {
        setState(() {
          test = true;
          changeButton();
        });
        // });
      },
      color: Colors.green,
      child: childButton,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      height: 230 + sizeu.width / 10,
      padding: EdgeInsets.fromLTRB(
          sizeu.width / 10, sizeu.width / 10, sizeu.width / 10, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          //background color of box
          // BoxShadow(
          //   color: Colors.black12,
          //   blurRadius: 0.5, // soften the shadow
          //   spreadRadius: .5, //extend the shadow
          //   offset: Offset(
          //     .5, // Move to right 10  horizontally
          //     .5, // Move to bottom 10 Vertically
          //   ),
          // ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Email',
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
              child: Text('Password',
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
              margin: EdgeInsets.only(top: 25),
              width: sizeu.width - sizeu.width / 5,
              height: 40,
              child: buttonSubmit),
        ],
      ),
    );
  }
}
