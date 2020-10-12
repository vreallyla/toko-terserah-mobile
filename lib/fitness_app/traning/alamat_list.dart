//import 'dart:ffi';

import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expandable/expandable.dart';
import 'package:http/http.dart';
import '../produk_detail/CustomShowDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:best_flutter_ui_templates/model/alamat_model.dart';
//import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

String tokenFixed = '';

class AlamatList extends StatefulWidget {
  @override
  _AlamatListState createState() => _AlamatListState();
}

class Post {
  String id;
  Post({this.id});

  factory Post.fromJson(Map json) {
    return Post(
      id: json['id'],
    );
  }
  Map toMap() {
    var map = new Map();
    map["id"] = id;
    return map;
  }
}

class PostCrate {
  String nama;
  String telp;
  String alamat;
  int kode_pos;
  int occupancy_id;
  int kecamatan_id;

  PostCrate({this.nama});

  factory PostCrate.fromJson(Map json) {
    return PostCrate(
      nama: json['id'],
    );
  }
  Map toMap() {
    var map = new Map();
    map["id"] = nama;
    return map;
  }
}

Future delPost(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return Post.fromJson(json.decode(response.body));
  });
}

var dataUserDefault;
var dataKecamatan;
List dataJenisAlamat;
List dataKota;

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
              print(globalBaseUrl + "api/address/delete/" + idx.toString());
              print(tokenFixed);
              Response response = await http.post(
                  globalBaseUrl + "api/address/delete/" + idx.toString(),
                  headers: {
                    "Accept": "application/json",
                    "Authorization":
                        "Bearer " + (tokenFixed != null ? tokenFixed : '')
                  });
              print(response.statusCode);
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Tidak"),
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

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenFixed = prefs.getString('token');
    dataUser = prefs.getString('dataUser');
    print(prefs.toString());
    print(globalBaseUrl + "api/address/kota");
    print(tokenFixed);
    var tempList;
    Response response =
        await http.get(globalBaseUrl + "api/address/kota", headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
    });
    tempList = await jsonDecode(response.body.toString());
    dataKota = tempList["data"]["city"];
    Response responseKcm =
        await http.get(globalBaseUrl + "api/address/kecamatan", headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
    });
//    print(dataKota["data"]["city"]);
    dataKecamatan = await jsonDecode(responseKcm.body.toString());
    print(dataKecamatan);
    if (dataUser != null) {
      dataUser = await jsonDecode(dataUser);
      print(dataUser['user']['get_alamat']);
      dataUserDefault = dataUser['user']['get_alamat'];
    }

    //the birthday's date

    // await initializeDateFormatting('id', null).then((value) {

    // }
    // );

    setState(() {});
  }

  @override
  void initState() {
    _getUser();

    super.initState();
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
                  onPressed: () => showAlertDialog(context, null),
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

class StatusTransaksi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      color: Colors.green[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    child: FaIcon(
                      FontAwesomeIcons.paperclip,
                      color: Colors.black54,
                      size: 18,
                    ),
                  ),
                  Container(
                      width: size.width - 30 - 100 - 30,
                      child: Text('Status',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ))),
                  Container(
                    width: 100,
                    alignment: Alignment.centerRight,
                    child: Text('20 Sept 2020',
                        style: TextStyle(
                          color: Colors.black54,
                        )),
                  )
                ],
              )),
          Container(
            padding: EdgeInsets.only(left: 30),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(width: 110, child: Text('No Invoice')),
                  Container(
                      width: size.width - 30 - 110 - 30,
                      child: Text(
                        ': 3012/sadki/21393',
                        maxLines: 2,
                      )),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(left: 30, top: 5),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 110,
                    child: Text('Telah Diterima'),
                  ),
                  Container(
                      width: size.width - 30 - 110 - 30,
                      child: Text(': 05 Agust 2020', maxLines: 2)),
                ]),
          ),
        ],
      ),
    );
  }
}

class AlamatTransaksi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var _tapPosition;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    void _storePosition(TapDownDetails details) {
      _tapPosition = details.globalPosition;
    }

    return ListView.builder(
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
                  // PopupMenuItem(
                  //   value: 0,
                  //   child: Row(
                  //     children: <Widget>[
                  //       Icon(Icons.edit, color: Colors.green),
                  //       Text("Edit"),
                  //     ],
                  //   ),
                  // ),
                  // PopupMenuItem(
                  //   value: 0,
                  //   child: Row(
                  //     children: <Widget>[
                  //       Icon(Icons.delete, color: Colors.green),
                  //       Text("Hapus"),
                  //     ],
                  //   ),
                  // ),
                  PopupMenuItem(
                    value: 0,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.home, color: Colors.green),
                        Text("Jadikan Alamat Utama"),
                      ],
                    ),
                  )
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
                                  image: AssetImage(
                                      locationOccupation + 'kontrakan.png'),
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
                          onTap: () => showAlertDialog(context, index),
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
                            onTap: () => confirmHapus(
                                context, dataUserDefault[index]["id"]),
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

class TrackerTransaksi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.5, color: Colors.black26),
        ),
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              child: FaIcon(
                FontAwesomeIcons.shippingFast,
                color: Colors.green,
                size: 18,
              ),
            ),
            Container(
                width: size.width - 30 - 100 - 30,
                child: Text('Status Pengiriman',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ))),
            Container(
              width: 100,
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {},
                child: Text('Lacak',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              ),
            )
          ],
        )),
        Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15, top: 10),
              padding: EdgeInsets.only(left: 15, bottom: 15),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 0.5, color: Colors.black54),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //lokasi tracker
                  Container(
                    width: size.width - 30 - 30,
                    child: Text(
                      '[lokasi akhir disini]',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: size.width - 30 - 30,
                    padding: EdgeInsets.only(top: 5),
                    child: Text('Nama Ekspedisi : Kode Ekspedisi'),
                  ),
                  Container(
                    width: size.width - 30 - 30,
                    padding: EdgeInsets.only(top: 5),
                    child: Text('20 Sept 2020',
                        style: TextStyle(color: Colors.green)),
                  )
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 10, left: 10.5),
                decoration: BoxDecoration(
                  color: Colors.green[300],
                ),
                height: 10,
                width: 10),
          ],
        )
      ]),
    );
  }
}

class HeadDaftarTransaksi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // daftar pesanan
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: ExpandablePanel(
            theme: ExpandableThemeData(
              iconColor: Colors.grey,
              // iconSize: 25,
              // iconPadding: EdgeInsets.only(bottom: 3),
              fadeCurve: Curves.linear,
              sizeCurve: Curves.fastOutSlowIn,
              hasIcon: false,
            ),
            header: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 30,
                  child: FaIcon(
                    FontAwesomeIcons.boxes,
                    color: Colors.green,
                    size: 18,
                  ),
                ),
                Container(
                    width: size.width - 30 - 30 - 100,
                    child: Text('Daftar Pesanan',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ))),
                Container(
                  width: 100,
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Lihat',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            expanded: Container(
              padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // daftar pesanan
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 70,
                          height: 70,
                          margin: EdgeInsets.only(right: 10),
                          color: Colors.grey,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 7),
                              width: size.width - 60 - 80,
                              child: Text(
                                'Nama Barang Disini',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                ),
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 7),
                              width: size.width - 60 - 80,
                              child: Text(
                                'X1',
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 7),
                              alignment: Alignment.topRight,
                              width: size.width - 60 - 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '(Rp500.000,-)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  Text(
                                    '  Rp10.000,-',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        //summary cost
        Container(
          decoration: borderTop(),
          margin: EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.only(left: 45, top: 15, bottom: 8, right: 15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //subtotal
                Container(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          width: 160,
                          child: Text('Subtotal',
                              style: TextStyle(
                                color: Colors.black54,
                              ))),
                      Container(
                          alignment: Alignment.topRight,
                          width: (size.width - 30 - 30) - 160,
                          child: Text('Rp10.000,-',
                              style: TextStyle(
                                color: Colors.black54,
                              ))),
                    ],
                  ),
                ),
                // pengiriman
                Container(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          width: 160,
                          child: Text('Pengiriman',
                              style: TextStyle(
                                color: Colors.black54,
                              ))),
                      Container(
                          alignment: Alignment.topRight,
                          width: (size.width - 30 - 30) - 160,
                          child: Text('Rp5.000,-',
                              style: TextStyle(
                                color: Colors.black54,
                              ))),
                    ],
                  ),
                ),
                // potongan voucher
                Container(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          width: 160,
                          child: Text('Potongan Voucher',
                              style: TextStyle(
                                color: Colors.black54,
                              ))),
                      Container(
                          alignment: Alignment.topRight,
                          width: (size.width - 30 - 30) - 160,
                          child: Text('Rp0,-',
                              style: TextStyle(
                                color: Colors.black54,
                              ))),
                    ],
                  ),
                ),

                //total pesanan
                Container(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.topLeft,
                          width: 160,
                          child: Text('Total Pesanan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ))),
                      Container(
                          alignment: Alignment.topRight,
                          width: (size.width - 30 - 30) - 160,
                          child: Text('Rp15.000,-',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ))),
                    ],
                  ),
                ),
              ]),
        ),
      ],
    );
  }
}

class TransaksiVia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        // border: Border(
        //   top: BorderSide(width: 0.5, color: Colors.black26),
        // ),
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              child: FaIcon(
                FontAwesomeIcons.commentsDollar,
                color: Colors.green,
                size: 18,
              ),
            ),
            Container(
                width: size.width - 30 - 100 - 30,
                child: Text('Metode Pembayaran',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ))),
            // Container(
            //   width: 100,
            //   alignment: Alignment.centerRight,
            //   child: InkWell(
            //     onTap: () {},
            //     child: Text('Lacak',
            //         style: TextStyle(
            //           color: Colors.green,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 16,
            //         )),
            //   ),
            // )
          ],
        )),
        Container(
          margin: EdgeInsets.only(left: 15, top: 10),
          padding: EdgeInsets.only(left: 15, bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //lokasi tracker
              Container(
                width: size.width - 30 - 30,
                child: Text(
                  'Bank BCA (Transfer Otomatis)',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ]),
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
