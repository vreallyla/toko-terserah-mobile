import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../register/register_screen_i.dart';
import './form_login_view.dart';

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

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Masuk',
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: BottomAppBar(
          child: Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Belum punya Akun? ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RegisterScreenI()));
                  },
                  child: Text(
                    'Daftar Sekarang',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              child: ListView(
                children: <Widget>[
                  formLoginView(),
                  DividerText(),
                  otherMethodButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DividerText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final sizeu = MediaQuery.of(context).size;

    return Container(
      child: Row(children: <Widget>[
        Expanded(child: Divider()),
        Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text(
              "ATAU",
              style: TextStyle(color: Colors.black54),
            )),
        Expanded(child: Divider()),
      ]),
    );
  }
}

class otherMethodButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      height: 230 + sizeu.width / 10,
      padding: EdgeInsets.fromLTRB(sizeu.width / 10, 15, sizeu.width / 10, 15),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 5),
              width: sizeu.width - sizeu.width / 5,
              height: 40,
              child: RaisedButton(
                onPressed: () {},
                color: Color(0xFFF2F2F2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.google,
                      size: 15,
                      color: Colors.red,
                    ),
                    Text(
                      '  Google',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              )),
          Container(
              margin: EdgeInsets.only(top: 10),
              width: sizeu.width - sizeu.width / 5,
              height: 40,
              child: RaisedButton(
                onPressed: () {},
                color: Colors.blue[600],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.facebookF,
                      size: 15,
                      color: Colors.white,
                    ),
                    Text(
                      '  Facebook',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// end stack end
