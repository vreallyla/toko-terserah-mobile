//import 'dart:ffi';

import 'package:tokoterserah/Constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expandable/expandable.dart';
import 'package:http/http.dart';
import '../produk_detail/CustomShowDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokoterserah/model/user_model.dart' as user_model;
//import 'package:tokoterserah/model/alamat_model.dart';
//import 'package:tokoterserah/Constant/Constant.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:http/http.dart' as http;

String tokenFixed = '';

class AlamatList extends StatefulWidget {
  final _AlamatListState als = _AlamatListState();
  void getuser() {
    als._getUser();
  }

  @override
  State<StatefulWidget> createState() => als;
  //_AlamatListState createState() => _AlamatListState();
}

final alamatlist = AlamatList();

var dataUserDefault;
var dataKecamatan;
List dataJenisAlamat;
List dataKota;
String ishapus = "n";

void showAlertDialog(BuildContext context, idx) {
  TextEditingController _namaController = new TextEditingController();
  TextEditingController _namapenerimaController = new TextEditingController();
  TextEditingController _alamatController = new TextEditingController();
  TextEditingController _telpController = new TextEditingController();
  TextEditingController _postalcodeController = new TextEditingController();
  if (idx == null) {
    _namaController.text = "";
    _namapenerimaController.text = "";
    _alamatController.text = "";
    _telpController.text = "";
    _postalcodeController.text = "";
  } else if (dataUserDefault[idx].length == null) {
    _namaController.text = "";
    _namapenerimaController.text = "";
    _alamatController.text = "";
    _telpController.text = "";
    _postalcodeController.text = "";
  } else {
    _namaController.text = dataUserDefault[idx]["get_occupancy"]["name"];
    _namapenerimaController.text = dataUserDefault[idx]["nama"];
    _alamatController.text = dataUserDefault[idx]["alamat"];
    _telpController.text = dataUserDefault[idx]["telp"];
    _postalcodeController.text = dataUserDefault[idx]["kode_pos"];
  }
  bool _validate = false;
  String _mySelection;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final namaField = TextFormField(
        maxLines: 1,
        controller: _namaController,
        keyboardType: TextInputType.name,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Nama Alamat',
          labelText: 'Nama Alamat :',
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          hintStyle: TextStyle(
            color: Colors.black,
          ),
        ),
      );

      final namapenerimaField = TextFormField(
        maxLines: 1,
        controller: _namapenerimaController,
        keyboardType: TextInputType.name,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
            hintText: 'Nama Penerima',
            labelText: 'Nama Penerima :',
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black,
            ),
            errorText: _validate ? 'Tidak Boleh Kosong' : null),
      );

      final telpField = TextFormField(
        maxLines: 1,
        controller: _telpController,
        keyboardType: TextInputType.phone,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
            hintText: 'Nomor Telepon',
            labelText: 'Nomor Telepon :',
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black,
            ),
            errorText: _validate ? 'Tidak Boleh Kosong' : null),
      );
      Map<String, String> body = {
        'nama': _namaController.text,
        'telp': _telpController.text,
        'alamat': _alamatController.text,
        'kode_pos': _postalcodeController.text,
        'occupancy_id': "0",
        'kecamatan_id': "0",
        'lat': "",
        'long': ""
      };
      final postalcodeField = TextFormField(
        maxLines: 1,
        controller: _postalcodeController,
        keyboardType: TextInputType.phone,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
            hintText: 'Kode Pos',
            labelText: 'Kode Pos :',
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black,
            ),
            errorText: _validate ? 'Tidak Boleh Kosong' : null),
      );
      final alamatField = TextFormField(
        maxLines: 2,
        controller: _alamatController,
        keyboardType: TextInputType.streetAddress,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
            hintText: 'Alamat',
            labelText: 'Alamat :',
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black,
            ),
            errorText: _validate ? 'Tidak Boleh Kosong' : null),
      );

      return CustomAlertDialog(
        content: Container(
          // width: MediaQuery.of(context).size.width + 200,
          height: MediaQuery.of(context).size.height + 100,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.only(right: 8, bottom: 15),
                  child: FaIcon(
                    FontAwesomeIcons.times,
                    color: Colors.black54,
                    size: 16,
                  ),
                ),
              ),
              namaField,
              namapenerimaField,
              telpField,
              alamatField,
              Text(
                "Kota :                                                                          ",
                textAlign: TextAlign.start,
              ),
              DropdownButton(
                isDense: true,
                items: dataKota.map((item) {
                  return new DropdownMenuItem(
                    child: new Text(item['nama']),
                    value: item['kota_id'].toString(),
                  );
                }).toList(),
                onChanged: (newVal) {
                  _mySelection = newVal;
                },
                value: _mySelection,
              ),
              Text(
                "Kecamatan :                                                                          ",
                textAlign: TextAlign.start,
              ),
              DropdownButton(
                isDense: true,
                items: dataKecamatan.map((item) {
                  return new DropdownMenuItem(
                    child: new Text(item['nama']),
                    value: item['kota_id'].toString(),
                  );
                }).toList(),
                onChanged: (newVal) {
                  _mySelection = newVal;
                },
                value: _mySelection,
              ),
              postalcodeField,
              MaterialButton(
                onPressed: () async {
                  if (_alamatController.text.isEmpty ||
                      _namaController.text.isEmpty ||
                      _namapenerimaController.text.isEmpty ||
                      _postalcodeController.text.isEmpty ||
                      _telpController.text.isEmpty) {
                    _validate = false;
                  } else {
                    if (idx != null) {
                      print(globalBaseUrl +
                          "api/address/update/" +
                          idx.toString());
                      print(tokenFixed);
                      Response response = await http.post(
                          globalBaseUrl +
                              "api/address/update/" +
                              idx.toString(),
                          headers: {
                            "Accept": "application/json",
                            "Authorization": "Bearer " +
                                (tokenFixed != null ? tokenFixed : ''),
                          },
                          body: body);
                      print(response.statusCode);
                    } else {
                      print(globalBaseUrl + "api/address/create");
                      print(tokenFixed);
                      Response response =
                          await http.post(globalBaseUrl + "api/address/create",
                              headers: {
                                "Accept": "application/json",
                                "Authorization": "Bearer " +
                                    (tokenFixed != null ? tokenFixed : '')
                              },
                              body: body);
                      print(response.body);
                    }
                  }

                  Navigator.of(context).pop();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 20,
                  //padding: EdgeInsets.all(14.0),
                  margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Material(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Simpan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: 'helvetica_neue_light',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _AlamatListState extends State<AlamatList> {
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  String nama, ava, bgPhoto, telp, alamat, utama;
  DateTime tglDaftar, tglUpdate;
  var dataUser;
  String diff;

  void _getUser() async {
    user_model.UserModel.akunRes();
    print('success');
    Future.delayed(Duration(seconds: 1), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (ishapus == "y") {
        await prefs.reload();
      }

      tokenFixed = prefs.getString('token');
      dataUser = prefs.getString('dataUser');
      print(prefs.getString('dataUser'));
      if (dataUser != null) {
        dataUser = await jsonDecode(dataUser);
        print(dataUser['user']['get_alamat']);
        dataUserDefault = dataUser['user']['get_alamat'];
      }
      if (ishapus == "n") {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    _getUser();

    super.initState();
  }

  confirmHapus(BuildContext context, idx) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text("Apakah anda yakin ingin menghapus data ini ?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ya"),
              onPressed: () async {
                ishapus = "y";
                print("https://tokoterserah.com/" +
                    "api/address/delete/" +
                    idx.toString());
                print(tokenFixed);
                Response response = await http.post(
                    "https://tokoterserah.com/" +
                        "api/address/delete/" +
                        idx.toString(),
                    headers: {
                      "Accept": "application/json",
                      "Authorization":
                          "Bearer " + (tokenFixed != null ? tokenFixed : '')
                    });
                var tempData;

                Response responsetemp = await http.get(
                    globalBaseUrl +
                        "api/address?user_id=" +
                        dataUserDefault[0]["user_id"].toString(),
                    headers: {
                      "Accept": "application/json",
                      "Authorization":
                          "Bearer " + (tokenFixed != null ? tokenFixed : '')
                    });
                tempData = await jsonDecode(responsetemp.body.toString());
                if (tempData != null) {
                  dataUserDefault = tempData["data"]["address"];
                }
                alamatlist.getuser();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "Hell no",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                //Put your code here which you want to execute on No button click.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.grey[200],
        title: const Text(
          'Daftar Alamat',
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: BottomAppBar(
            child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 15,
                  right: 15,
                ),
                child: RaisedButton(
                  onPressed: () => Navigator.pushNamed(context, '/inputalamat',
                          arguments: null)
                      .then((value) async {
                    // _getUser();
                    var tempData;

                    Response responsetemp = await http.get(
                        globalBaseUrl +
                            "api/address?user_id=" +
                            dataUserDefault[0]["user_id"].toString(),
                        headers: {
                          "Accept": "application/json",
                          "Authorization":
                              "Bearer " + (tokenFixed != null ? tokenFixed : '')
                        });
                    tempData = await jsonDecode(responsetemp.body.toString());
                    if (tempData != null) {
                      dataUserDefault = tempData["data"]["address"];
                    }

                    setState(() {
                      // refresh state
                    });
                  }),
                  child: Text(
                    'TAMBAH ALAMAT',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                ))),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: AlamatTransaksi(),
      ),
    );
  }
}
// end stack end

class AlamatTransaksi extends StatefulWidget {
  @override
  _AlamatTransaksiState createState() => _AlamatTransaksiState();
}

//Konten Alamat
class _AlamatTransaksiState extends State<AlamatTransaksi> {
  @override
  void initState() {
    if (this.mounted) {
      setState(() {});
    }

    super.initState();
  }

  var dataUser;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var _tapPosition;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    void _storePosition(TapDownDetails details) {
      _tapPosition = details.globalPosition;
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: dataUserDefault == null ? 0 : dataUserDefault.length,
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
            onTapDown: _storePosition,
            onTap: () {
              showMenu(
                position: RelativeRect.fromRect(
                    _tapPosition &
                        const Size(40, 40), // smaller rect, the touch area
                    Offset.zero & overlay.size // Bigger rect, the entire screen
                    ),
                //onSelected: () => setState(() => imageList.remove(index)),
                items: <PopupMenuEntry>[
                  PopupMenuItem(
                      value: 0,
                      child: InkWell(
                        onTap: () async {
                          print("https://tokoterserah.com/" +
                              "api/address/set_utama/" +
                              dataUserDefault[index]["id"].toString());
                          print(tokenFixed);
                          Response response = await http.post(
                              "https://tokoterserah.com/" +
                                  "api/address/set_utama/" +
                                  dataUserDefault[index]["id"].toString(),
                              headers: {
                                "Accept": "application/json",
                                "Authorization": "Bearer " +
                                    (tokenFixed != null ? tokenFixed : '')
                              });
                          var tempData;

                          Response responsetemp = await http.get(
                              globalBaseUrl +
                                  "api/address?user_id=" +
                                  dataUserDefault[0]["user_id"].toString(),
                              headers: {
                                "Accept": "application/json",
                                "Authorization": "Bearer " +
                                    (tokenFixed != null ? tokenFixed : '')
                              });
                          tempData =
                              await jsonDecode(responsetemp.body.toString());
                          if (tempData != null) {
                            dataUserDefault = tempData["data"]["address"];
                          }

                          setState(() {
                            // refresh state
                          });

                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.home, color: Colors.green),
                            Text("Jadikan Alamat Utama"),
                          ],
                        ),
                      ))
                ],
                context: context,
              );
            },
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(4.0),
                        topRight: const Radius.circular(4.0),
                      )),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                top: 4,
                              ),
                              margin: EdgeInsets.only(right: 10),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(locationOccupation +
                                      dataUserDefault[index]["get_occupancy"]
                                          ["image"]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                                width: size.width - 30 - 120 - 30 - 20,
                                child: Text(
                                    dataUserDefault[index]["get_occupancy"]
                                        ["name"],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ))),
                            Container(
                              width: 120,
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                    dataUserDefault[index]["isUtama"] == 1
                                        ? "Alamat Utama"
                                        : '',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    )),
                              ),
                            )
                          ],
                        )),
                        //nama
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 15,
                                  padding: EdgeInsets.only(top: 2),
                                  child: FaIcon(
                                    FontAwesomeIcons.idCard,
                                    size: 13,
                                    color: Colors.black45,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Container(
                                    width: size.width - 30 - 30 - 10 - 20,
                                    child: Text(
                                      dataUserDefault[index]["nama"],
                                      maxLines: 1,
                                    )),
                              ]),
                        ),
                        // no telp
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 15,
                                  padding: EdgeInsets.only(top: 2),
                                  child: FaIcon(
                                    FontAwesomeIcons.phone,
                                    size: 13,
                                    color: Colors.black45,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Container(
                                    width: size.width - 30 - 30 - 10 - 20,
                                    child: Text(
                                      dataUserDefault[index]["telp"],
                                      maxLines: 1,
                                    )),
                              ]),
                        ),
                        // alamat
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 15,
                                  padding: EdgeInsets.only(top: 2),
                                  child: FaIcon(
                                    FontAwesomeIcons.mapMarkedAlt,
                                    size: 13,
                                    color: Colors.black45,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Container(
                                    width: size.width - 30 - 30 - 10 - 20,
                                    child: Text(
                                      dataUserDefault[index]["alamat"],
                                      maxLines: 4,
                                    )),
                              ]),
                        ),
                      ]),
                ),
                //footer button
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                        bottomLeft: const Radius.circular(4.0),
                        bottomRight: const Radius.circular(4.0),
                      )),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(width: .5, color: Colors.black26),
                          ),
                        ),
                        width: (size.width - 40) / 2,
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(
                                  context, '/inputalamat',
                                  arguments: dataUserDefault[index])
                              .then((value) async {
                            var tempData;

                            Response responsetemp = await http.get(
                                globalBaseUrl +
                                    "api/address?user_id=" +
                                    dataUserDefault[0]["user_id"].toString(),
                                headers: {
                                  "Accept": "application/json",
                                  "Authorization": "Bearer " +
                                      (tokenFixed != null ? tokenFixed : '')
                                });
                            tempData =
                                await jsonDecode(responsetemp.body.toString());
                            if (tempData != null) {
                              dataUserDefault = tempData["data"]["address"];
                            }

                            setState(() {
                              // refresh state
                            });
                          }),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.edit,
                                size: 16,
                                color: Colors.orange,
                              ),
                              Text(' SUNTING',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.orange[600])),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: (size.width - 40) / 2,
                          child: InkWell(
                            onTap: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Konfirmasi'),
                                  content: Text(
                                      "Apakah anda yakin ingin menghapus data ini ?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Ya"),
                                      onPressed: () async {
                                        ishapus = "y";
                                        print("https://tokoterserah.com/" +
                                            "api/address/delete/" +
                                            dataUserDefault[index]["id"]
                                                .toString());
                                        print(tokenFixed);
                                        Response response = await http.post(
                                            "https://tokoterserah.com/" +
                                                "api/address/delete/" +
                                                dataUserDefault[index]["id"]
                                                    .toString(),
                                            headers: {
                                              "Accept": "application/json",
                                              "Authorization": "Bearer " +
                                                  (tokenFixed != null
                                                      ? tokenFixed
                                                      : '')
                                            });
                                        var tempData;

                                        Response responsetemp = await http.get(
                                            globalBaseUrl +
                                                "api/address?user_id=" +
                                                dataUserDefault[0]["user_id"]
                                                    .toString(),
                                            headers: {
                                              "Accept": "application/json",
                                              "Authorization": "Bearer " +
                                                  (tokenFixed != null
                                                      ? tokenFixed
                                                      : '')
                                            });
                                        tempData = await jsonDecode(
                                            responsetemp.body.toString());
                                        if (tempData != null) {
                                          dataUserDefault =
                                              tempData["data"]["address"];
                                        }
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        "Tidak",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        //Put your code here which you want to execute on No button click.
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.eraser,
                                  size: 16,
                                  color: Colors.red[600],
                                ),
                                Text(' HAPUS',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red)),
                              ],
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ));
      },
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
