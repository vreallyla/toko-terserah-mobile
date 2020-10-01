import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:expandable/expandable.dart';
import 'package:icon_shadow/icon_shadow.dart';

class ProfileDetailScreen extends StatefulWidget {
  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

enum SingingCharacter { lafayette, jefferson }

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  SingingCharacter _character = SingingCharacter.lafayette;
  Container inputForm(context) {
    // final sizeu = MediaQuery.of(context).size;
    

    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Nama Lengkap',
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold))),
          SizedBox(
            // width: sizeu.width - sizeu.width / 5,
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
                hintText: 'Masukkan Nama Lengkap',
              ),
            ),
          ),
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 10, top: 10),
              child: Text('Tanggal Lahir',
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold))),
          SizedBox(
            // width: sizeu.width - sizeu.width / 5,
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
                hintText: 'Masukkan Tanggal Lahir',
              ),
            ),
          ),
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 10, top: 10),
              child: Text('Jenis Kelamin',
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold))),
          Container(
              // width: sizeu.width - sizeu.width / 5,

              child: Row(
            children: <Widget>[
              ListTile(
                title: const Text('Lafayette'),
                leading: Radio(
                  value: SingingCharacter.lafayette,
                  groupValue: _character,
                  onChanged: (SingingCharacter value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
              
            ],
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;
    return new Scaffold(
        body: Stack(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: 180,
              color: Colors.green,
            ),
            Container(
              //My container or any other widget
              color: Colors.white,

              child: ListView(children: <Widget>[
                AtasGambar(),
                inputForm(context),
              ]),
            ),
          ],
        ),
        new Positioned(
          //Place it at the top, and not use the entire screen
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(
            leading: IconButton(
              icon: IconShadowWidget(
                Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 36,
                ),
                shadowColor: Colors.black54,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),

            backgroundColor: Colors.transparent, //No more green
            elevation: 0.0, //Shadow gone
          ),
        ),
      ],
    ));
  }
}
// end stack end

class AtasGambar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        // Navigator.pushNamed(context, '/profile_detail');
      },
      child: Stack(
        children: <Widget>[
          Container(
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fitness_app/bg_users.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
          ),
          Container(
            height: 180,
            decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(.6),
                    ],
                    stops: [
                      0.0,
                      1.0
                    ])),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
          ),
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                margin: EdgeInsets.only(
                    top: 120, left: sizeu.width / 2 - 60, bottom: 15),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green[200],
                      width: 3.0,
                    ),
                    shape: BoxShape.circle,
                    color: Colors.grey),
                child: Container(
                  height: 30,
                  margin: EdgeInsets.only(top: 70, bottom: 20),
                  alignment: Alignment.center,
                ),
              ),
              Container(
                width: 120,
                height: 120,
                margin: EdgeInsets.only(
                    top: 120, left: sizeu.width / 2 - 60, bottom: 15),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.transparent,
                      width: 3.0,
                    ),
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(.4),
                        ],
                        stops: [
                          0.7,
                          0.3
                        ])),
                child: Container(
                  height: 30,
                  margin: EdgeInsets.only(top: 80, bottom: 10),
                  alignment: Alignment.center,
                  // color: Colors.red,
                  child: Text('Ubah Photo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      )),
                  // decoration: BoxDecoration(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

BoxDecoration borderTop() {
  return BoxDecoration(
    border: Border(
      top: BorderSide(width: 0.5, color: Colors.black26),
    ),
    color: Colors.white,
  );
}
