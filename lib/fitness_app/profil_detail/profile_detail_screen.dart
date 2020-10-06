import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:expandable/expandable.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:intl/intl.dart';

class ProfileDetailScreen extends StatefulWidget {
  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

enum SingingCharacter { lafayette, jefferson }

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  SingingCharacter _character = SingingCharacter.lafayette;
  Container inputForm(context) {
    final sizeu = MediaQuery.of(context).size;
    String _gendeRadioButton; //Initial definition of radio button value
    String msgJenisKelamin;
    final myformat = DateFormat("yyyy-MM-dd");
    DateTime selectedDate = DateTime.now();
    TextEditingController tglLahirInput = new TextEditingController();
    String msgTL;

    Future<Null> selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  surface: Colors.green[100],
                  onSurface: Colors.black,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child,
            );
          },
          initialDate: selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          tglLahirInput.text = myformat.format(selectedDate);
        });
    }

    TextEditingController no_telp = new TextEditingController();
    String msgNoTelp;

    void radioButtonChanges(String value) {
      setState(() {
        setState(() {
          _gendeRadioButton = value;
        });
        debugPrint(_gendeRadioButton); //Debug the choice in console
      });
    }

    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
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
          //gender
          Container(
            // padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            padding: EdgeInsets.only(top: 10),
            width: sizeu.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('Jenis Kelamin',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold))),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _gendeRadioButton = 'pria';
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(right: 5),
                        width: (sizeu.width - 50) / 3,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black54,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: Radio(
                                activeColor: Colors.green,
                                value: 'pria',
                                groupValue: _gendeRadioButton,
                                onChanged: radioButtonChanges,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 6),
                              child: Text(
                                "Pria",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _gendeRadioButton = 'wanita';
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(right: 5),
                        width: (sizeu.width - 50) / 3,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black54,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: Radio(
                                activeColor: Colors.green,
                                value: 'wanita',
                                groupValue: _gendeRadioButton,
                                onChanged: radioButtonChanges,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 6),
                              child: Text(
                                "Wanita",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _gendeRadioButton = 'lainnya';
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        // margin: EdgeInsets.only(right:5),
                        width: (sizeu.width - 50) / 3,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black54,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: Radio(
                                activeColor: Colors.green,
                                value: 'lainnya',
                                groupValue: _gendeRadioButton,
                                onChanged: radioButtonChanges,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 6),
                              child: Text(
                                "Lainnya",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //message jenis kelamin
                hintMsg(msgJenisKelamin),
              ],
            ),
          ),

          // tanggal lahir
          Container(
            width: sizeu.width,
            // padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            padding: EdgeInsets.only(top:10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('Tanggal Lahir',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold))),
                SizedBox(
                  width: sizeu.width - 30,
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      selectDate(
                          context); // Call Function that has showDatePicker()
                    },
                    child: IgnorePointer(
                      child: SizedBox(
                        width: sizeu.width - 30,
                        height: 40,
                        child: TextFormField(
                          controller: tglLahirInput,
                          decoration:
                              defaultInput('Pilih Tanggal Lahir', false),
                          onSaved: (String val) {},
                        ),
                      ),
                    ),
                  ),
                ),
                //message ttl
                hintMsg(msgTL),
              ],
            ),
          ),

          Container(
            // padding: EdgeInsets.fromLTRB(15, 20, 15, 5),
            padding: EdgeInsets.only(top: 10),
            width: sizeu.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('No. Telp',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold))),
                SizedBox(
                  width: sizeu.width - 30,
                  height: 40,
                  child: TextField(
                      // enabled: false,
                      textAlign: TextAlign.left,
                      controller: no_telp,
                      onChanged: (text) {
                        setState(() {});
                      },
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: defaultInput('Masukkan No. Telp', false)),
                ),
                hintMsg(msgNoTelp),
              ],
            ),
          ),
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
              color: Colors.grey.withOpacity(0.2),

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
                width: 100,
                height: 100,
                // margin: EdgeInsets.only(
                //     top: 120, left: sizeu.width / 2 - 60, bottom: 15),
                margin: EdgeInsets.only(left: sizeu.width / 2 - 50, top: 40),
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
                width: 100,
                height: 100,
                // margin: EdgeInsets.only(
                //     top: 120, left: sizeu.width / 2 - 60, bottom: 15),
                margin: EdgeInsets.only(left: sizeu.width / 2 - 50, top: 40),
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
                  // margin: EdgeInsets.only(top: 80, bottom: 10),
                  margin: EdgeInsets.only(top: 60),
                  alignment: Alignment.center,
                  // color: Colors.red,
                  child: Text('SUNTING',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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

InputDecoration defaultInput(String hint, bool dis) {
  return new InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black54, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black38, width: 1),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black38, width: 1),
    ),
    hintText: hint,
    fillColor: dis ? Colors.grey.withOpacity(.2) : Colors.white,
    filled: true,
  );
}

Container hintMsg(String msg) {
  return Container(
    padding: EdgeInsets.only(top: 4),
    child: Text(
      (msg != null ? msg : ''),
      style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
          fontSize: (msg != null ? 13 : 0)),
    ),
  );
}

BoxDecoration borderTop() {
  return BoxDecoration(
    border: Border(
      top: BorderSide(width: 0.5, color: Colors.black26),
    ),
    color: Colors.white,
  );
}
