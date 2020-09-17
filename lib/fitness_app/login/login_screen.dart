import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:best_flutter_ui_templates/fitness_app/fintness_app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Masuk',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[formLogin(), dividerText()],
          ),
        ),
      ),
    );
  }
}

class formLogin extends StatelessWidget {
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
              textAlign: TextAlign.left,
              onChanged: (text) => {},
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
              textAlign: TextAlign.left,
              onChanged: (text) => {},
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
              child: RaisedButton(
                onPressed: () {},
                color: Colors.green,
                child: Text(
                  'Masuk',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}

class dividerText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      
      child: Row(children: <Widget>[
        Expanded(child: Divider()),
        Container(padding:EdgeInsets.only(left:10,right:10),child: Text("OR")),
        Expanded(child: Divider()),
      ]),
    );
  }
}

// end stack end
