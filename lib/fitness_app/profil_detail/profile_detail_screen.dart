import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:expandable/expandable.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:async/async.dart';

class ProfileDetailScreen extends StatefulWidget {
  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

enum SingingCharacter { lafayette, jefferson }

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  SingingCharacter _character = SingingCharacter.lafayette;

  String _gendeRadioButton; //Initial definition of radio button value
  String msgJenisKelamin;
  final myformat = DateFormat("yyyy-MM-dd");
  DateTime selectedDate = DateTime.now();

  TextEditingController namaLengkapInput = new TextEditingController();
  TextEditingController tglLahirInput = new TextEditingController();
  String msgTL, _token, _ava;
  var dataUser;
  File _image;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController passwordInput = new TextEditingController();
  FaIcon seePass = FaIcon(FontAwesomeIcons.eye);
  bool occuText = true;
  bool isLoading = true;
  String msgPass;

  TextEditingController emailInput = new TextEditingController();
  String messageEmail;

  TextEditingController usernameInput = new TextEditingController();
  String messageUsername;

  TextEditingController telpInput = new TextEditingController();
  String messageTelp;

  TextEditingController rePassInput = new TextEditingController();

  TextEditingController confirmPassInput = new TextEditingController();

  _getCountCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      dataUser = prefs.getString('dataUser');

      // if (dataUser != null) {
      //   dataUser = await jsonDecode(dataUser);
      // }

      // get data user from API fetch
      var response = await http.get(globalBaseUrl + 'api/auth/user',
          headers: {'Authorization': 'bearer ' + _token});

      dataUser = await json.decode(response.body);

      setState(() {
        namaLengkapInput.text = dataUser['data']['user']['name'];
        tglLahirInput.text = dataUser['data']['user']['get_bio']['dob'];
        telpInput.text = dataUser['data']['user']['get_bio']['phone'];
        emailInput.text = dataUser['data']['user']['email'];
        usernameInput.text = dataUser['data']['user']['username'];
        _ava = dataUser['data']['user']['get_bio']['ava'];
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  /**
   * Ambil Gambar via kamera 
   * 
   */
  Future getImageCamera(context) async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _showPicker(context);
      } else {
        print('No image selected.');
      }
    });
  }

  /**
   * Ambil Gambar via Gallery
   * 
   */
  Future getImageGalerry(context) async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _showPicker(context);
      } else {
        print('No image selected.');
      }
    });
  }

  /**
   * Cutom Alert response
   * 
   */
  showSnackBar(String value, Color color, Icon icons) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Row(
        children: <Widget>[
          icons,
          SizedBox(
            width: 20,
          ),
          Text(value)
        ],
      ),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ));
  }

/**
 * Todo Update bio 
 * return alert 
 * 
 */
  Future updateBio() async {
    try {
      final response =
          await http.post(globalBaseUrl + 'api/profile/update/bio', body: {
        'user_id': dataUser['data']['user']['id'].toString(),
        'gender': 'pria',
        'dob': tglLahirInput.text.toString(),
        'phone': telpInput.text.toString(),
        'name': namaLengkapInput.text
      }, headers: {
        'Authorization': 'bearer ' + _token
      });

      if (response.statusCode == 200) {
        showSnackBar("Berhasil Memperbarui Profil", Colors.green,
            Icon(Icons.check_circle_outline));
        setState(() {});
      } else {
        print(json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
  }

/**
 * Todo update Password
 * 
 */
  Future updatePassword() async {

    print("hallo");
    try {
      final response =
          await http.post(globalBaseUrl + 'api/profile/update/password', body: {
        'user_id': dataUser['data']['user']['id'].toString(),
        'password': passwordInput.text,
        'new_password': rePassInput.text,
        'password_confirmation': confirmPassInput.text
      }, headers: {
        'Authorization': 'bearer ' + _token
      });

      if (response.statusCode == 200) {
        showSnackBar("Berhasil Memperbarui Password", Colors.green,
            Icon(Icons.check_circle_outline));
        setState(() {});
      } else if (response.statusCode == 500) {
        var msg = json.decode(response.body);
        showSnackBar(
            msg['data']['message'], Colors.redAccent, Icon(Icons.close));
      }
    } catch (e) {
      print(e);
    }
  }

  /**
   * Upload Avatar with multipart http 
   */
  uploadAva() async {
    print("Hallo");
    try {
      print("object");
      var stream =
          new http.ByteStream(DelegatingStream.typed(_image.openRead()));
      var length = await _image.length();
      var uri = Uri.parse(
        globalBaseUrl + "api/profile/upload/ava",
      );

      var request = new http.MultipartRequest("POST", uri);

      var multipart = new http.MultipartFile("ava", stream, length,
          filename: path.basename(_image.path));
      request.headers.addAll({'Authorization': 'bearer ' + _token});
      request.fields
          .addAll({"user_id": dataUser['data']['user']['id'].toString()});
      request.files.add(multipart);

      var response = await request.send();
      if (response.statusCode == 200) {
        showSnackBar("Berhasil Memperbarui Profil", Colors.green,
            Icon(Icons.check_circle_outline));
        setState(() {
          isLoading = true;
        });

        _getCountCart();
      }
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }

  Container inputForm(context) {
    final sizeu = MediaQuery.of(context).size;

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
              controller: namaLengkapInput,
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
            padding: EdgeInsets.only(top: 10),
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
          //no telp
          Container(
            // padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            width: sizeu.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(bottom: 10, top: 10),
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
                      controller: telpInput,
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        setState(() {});
                      },
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: defaultInput('Masukkan No. Telp', false)),
                ),
                hintMsg(messageTelp),
              ],
            ),
          ),
          // button profil
          Container(
              width: sizeu.width - 30,
              padding: EdgeInsets.only(top: 15),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(4.0),
                ),
                child: Text(
                  'SIMPAN PERUBAHAN',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  updateBio();
                },
                color: Colors.green,
              ))
        ],
      ),
    );
  }

  Container akunFrom(context) {
    final sizeu = MediaQuery.of(context).size;

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
          //email
          Container(
            // padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            width: sizeu.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('Email',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold))),
                SizedBox(
                  width: sizeu.width - 30,
                  height: 40,
                  child: TextField(
                      enabled: false,
                      textAlign: TextAlign.left,
                      controller: emailInput,
                      onChanged: (text) {
                        setState(() {});
                      },
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: defaultInput('Masukkan Email', true)),
                ),
                hintMsg(messageEmail),
              ],
            ),
          ),
          //username
          Container(
            // padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            width: sizeu.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    child: Text('Username',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold))),
                SizedBox(
                  width: sizeu.width - 30,
                  height: 40,
                  child: TextField(
                      enabled: false,
                      textAlign: TextAlign.left,
                      controller: usernameInput,
                      onChanged: (text) {
                        setState(() {});
                      },
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: defaultInput('Masukkan Username', true)),
                ),
                hintMsg(messageUsername),
              ],
            ),
          ),

          //password
          Container(
            // padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            padding: EdgeInsets.only(top: 5),
            width: sizeu.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('Password',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold))),
                SizedBox(
                  width: sizeu.width - 30,
                  height: 40,
                  child: Stack(
                    children: [
                      TextField(
                          obscureText: occuText,
                          textAlign: TextAlign.left,
                          controller: passwordInput,
                          onChanged: (text) {
                            setState(() {});
                          },
                          onSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          decoration: defaultInput('Masukkan Password', false)),
                      Container(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 36,
                          child: IconButton(
                            icon: seePass,
                            tooltip: 'Lihat Password',
                            color: Colors.black38,
                            iconSize: 15,
                            onPressed: () {
                              if (occuText) {
                                seePass = FaIcon(FontAwesomeIcons.eyeSlash);
                                occuText = false;
                              } else {
                                seePass = FaIcon(FontAwesomeIcons.eye);
                                occuText = true;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //msg password
                hintMsg(msgPass),
              ],
            ),
          ),
          Container(
            // padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            padding: EdgeInsets.only(top: 5),
            width: sizeu.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('Password Baru',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold))),
                SizedBox(
                  width: sizeu.width - 30,
                  height: 40,
                  child: Stack(
                    children: [
                      TextField(
                          obscureText: occuText,
                          textAlign: TextAlign.left,
                          controller: rePassInput,
                          onChanged: (text) {
                            setState(() {});
                          },
                          onSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          decoration: defaultInput('Masukkan Password', false)),
                      Container(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 36,
                          child: IconButton(
                            icon: seePass,
                            tooltip: 'Lihat Password',
                            color: Colors.black38,
                            iconSize: 15,
                            onPressed: () {
                              if (occuText) {
                                seePass = FaIcon(FontAwesomeIcons.eyeSlash);
                                occuText = false;
                              } else {
                                seePass = FaIcon(FontAwesomeIcons.eye);
                                occuText = true;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //msg password
                hintMsg(msgPass),
              ],
            ),
          ),
          Container(
            // padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            padding: EdgeInsets.only(top: 5),
            width: sizeu.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('Ketik Ulang Password Baru',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold))),
                SizedBox(
                  width: sizeu.width - 30,
                  height: 40,
                  child: Stack(
                    children: [
                      TextField(
                          obscureText: occuText,
                          textAlign: TextAlign.left,
                          controller: confirmPassInput,
                          onChanged: (text) {
                            setState(() {});
                          },
                          onSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          decoration: defaultInput('Masukkan Password', false)),
                      Container(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 36,
                          child: IconButton(
                            icon: seePass,
                            tooltip: 'Lihat Password',
                            color: Colors.black38,
                            iconSize: 15,
                            onPressed: () {
                              if (occuText) {
                                seePass = FaIcon(FontAwesomeIcons.eyeSlash);
                                occuText = false;
                              } else {
                                seePass = FaIcon(FontAwesomeIcons.eye);
                                occuText = true;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //msg password
                hintMsg(msgPass),
              ],
            ),
          ),
          // button profil
          Container(
              width: sizeu.width - 30,
              padding: EdgeInsets.only(top: 15),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(4.0),
                ),
                child: Text(
                  'UBAH PASSWORD',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  updatePassword();
                },
                color: Colors.green,
              ))
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCountCart();
    super.initState();
  }

  /**
   * Bottom Sheet Section
   * 
   */
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  _image != null
                      ? Wrap(
                          children: [
                            Center(
                                child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            )),
                            new ListTile(
                                leading: new Icon(Icons.file_upload),
                                title: new Text('Upload gambar'),
                                onTap: () {
                                  uploadAva();
                                  Navigator.of(context).pop();
                                }),
                            new ListTile(
                                leading: new Icon(Icons.photo_library),
                                title: new Text('Ambil dari galleri'),
                                onTap: () {
                                  getImageGalerry(context);
                                  Navigator.of(context).pop();
                                }),
                            new ListTile(
                              leading: new Icon(Icons.photo_camera),
                              title: new Text('Ambil dari kamera'),
                              onTap: () {
                                getImageCamera(context);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                      : Wrap(
                          children: [
                            new ListTile(
                                leading: new Icon(Icons.photo_library),
                                title: new Text('Ambil dari galleri'),
                                onTap: () {
                                  getImageGalerry(context);
                                  Navigator.of(context).pop();
                                }),
                            new ListTile(
                              leading: new Icon(Icons.photo_camera),
                              title: new Text('Ambil dari kamera'),
                              onTap: () {
                                getImageCamera(context);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;
    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: new Scaffold(
          key: _scaffoldKey,
          body: isLoading
              ? reqLoad()
              : Stack(
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
                            headerAva(context),
                            inputForm(context),
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                            ),
                            akunFrom(context),
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
                )),
    );
  }

  Widget headerAva(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        _showPicker(context);
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
                    image: new DecorationImage(
                      //Todo render image from API
                      image: NetworkImage(
                          'http://101.50.0.89/storage/users/ava/' + _ava ??
                              'https://via.placeholder.com/300'),
                      fit: BoxFit.cover,
                    ),
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
// end stack end

class AtasGambar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {}
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
