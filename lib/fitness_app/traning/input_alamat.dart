//import 'dart:ffi';
import 'package:tokoterserah/fitness_app/fintness_app_theme.dart';
import 'package:tokoterserah/Constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:tokoterserah/model/alamat_model.dart';
//import 'package:tokoterserah/Constant/Constant.dart';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

String tokenFixed = '';
bool _validate = false;

class InputAlamat extends StatefulWidget {
  @override
  _InputAlamatState createState() => _InputAlamatState();
}

var dataUserDefault;
List dataKecamatan;
List dataJenisAlamat;
List dataKota;
List dataOcc;
var dataEdit;
List dataProv;
TextEditingController _namaController = new TextEditingController();
TextEditingController _namapenerimaController = new TextEditingController();
TextEditingController _alamatController = new TextEditingController();
TextEditingController _telpController = new TextEditingController();
TextEditingController _postalcodeController = new TextEditingController();
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

class _InputAlamatState extends State<InputAlamat> {
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  String nama, ava, bgPhoto, telp, alamat, utama;
  DateTime tglDaftar, tglUpdate;
  var dataUser;
  String diff;
  String idxalamat;

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenFixed = prefs.getString('token');
    dataUser = prefs.getString('dataUser');

    var tempList;
    var tempocc;
    var tempProv;

    Response responseprov =
        await http.get(globalBaseUrl + "api/address/provinsi", headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
    });
    tempProv = await jsonDecode(responseprov.body.toString());
    if (tempProv != null) {
      dataProv = tempProv["data"]["province"];
    }

    Response responseocc =
        await http.get(globalBaseUrl + "api/address/occupancy", headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
    });
    tempocc = await jsonDecode(responseocc.body.toString());
    if (tempocc != null) {
      dataOcc = tempocc["data"]["city"];
    }
    // Response response =
    //     await http.get(globalBaseUrl + "api/address/kota", headers: {
    //   "Accept": "application/json",
    //   "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
    // });
    // tempList = await jsonDecode(response.body.toString());
    // dataKota = tempList["data"]["city"];
    // print(dataKota);
    // Response responseKcm = await http
    //     .get(globalBaseUrl + "api/address/kecamatan?kota_id=1", headers: {
    //   "Accept": "application/json",
    //   "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
    // });
    // var tempList2;
    // tempList2 = await jsonDecode(responseKcm.body.toString());

    // print(tempList2["data"]["district"]);
    // dataKecamatan = tempList2["data"]["district"];

//    print(dataKota["data"]["city"]);
    //dataKecamatan = await jsonDecode(responseKcm.body.toString());
    // print(dataKecamatan);
    if (dataUser != null) {
      dataUser = await jsonDecode(dataUser);
      dataUserDefault = dataUser['user']['get_alamat'];
    }

    //the birthday's date

    // await initializeDateFormatting('id', null).then((value) {

    // }
    // );
    if (this.mounted) {
      setState(() {});
    }
  }

  _getDetailuser() async {
    // print(globalBaseUrl + "api/address/kota");
    var tempProv;
    var tempKota;
    var tempCamat;
    Response responseprov = await http
        .get(globalBaseUrl + "api/address/detail/" + idxalamat, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
    });
    tempProv = await jsonDecode(responseprov.body.toString());
    dataEdit = tempProv["data"];

    print("data edit : " + dataEdit.toString());
    if (dataEdit != null) {
      _mySelection3 = dataEdit["occupancy_id"]["id"].toString();
      _mySelection = dataEdit["kota_id"].toString();
      _mySelection2 = dataEdit["kecamatan_id"].toString();
      _mySelectionProv = dataEdit["provinsi_id"].toString();

      _namaController.text = dataEdit["occupancy_id"]["name"];
      _namapenerimaController.text = dataEdit["nama"];
      _alamatController.text = dataEdit["alamat"];
      _telpController.text = dataEdit["telp"];
      _postalcodeController.text = dataEdit["kode_pos"];
      Response responsekota = await http.get(
          globalBaseUrl + "api/address/kota?provinsi_id=" + _mySelectionProv,
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
          });
      tempKota = await jsonDecode(responsekota.body.toString());
      if (tempKota != null) {
        dataKota = tempKota["data"]["city"];
      }
      Response responsecamat = await http.get(
          globalBaseUrl + "api/address/kecamatan?kota_id=" + _mySelection,
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer " + (tokenFixed != null ? tokenFixed : '')
          });
      tempCamat = await jsonDecode(responsecamat.body.toString());
      if (tempCamat != null) {
        dataKecamatan = tempCamat["data"]["district"];
      }
    }

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dynamic args = ModalRoute.of(context).settings.arguments;
    print(args);
    if (args == null) {
      _namaController.text = "";
      _namapenerimaController.text = "";
      _alamatController.text = "";
      _telpController.text = "";
      _postalcodeController.text = "";
    } else if (args.length == null) {
      _namaController.text = "";
      _namapenerimaController.text = "";
      _alamatController.text = "";
      _telpController.text = "";
      _postalcodeController.text = "";
    } else {
      idxalamat = args["id"].toString();
      if (dataEdit == null) {
        _namaController.text = "";
        _namapenerimaController.text = "";
        _alamatController.text = "";
        _telpController.text = "";
        _postalcodeController.text = "";
        _getDetailuser();
      }
    }
    //final wh_ = MediaQuery.of(context).size;
    return new Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.grey[200],
          title: const Text(
            'Input / Edit Alamat',
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
                    onPressed: () async {
                      String globalBaseUrl2 = "https://tokoterserah.com/";
                      body = {
                        'nama': _namapenerimaController.text,
                        'telp': _telpController.text,
                        'alamat': _alamatController.text,
                        'kode_pos': _postalcodeController.text,
                        'occupancy_id': _mySelection3.toString(),
                        'provinsi_id': _mySelectionProv,
                        'kota_id': _mySelection,
                        'kecamatan_id': _mySelection2,
                        'lat': "",
                        'long': ""
                      };
                      if (_alamatController.text.isEmpty ||
                          _namapenerimaController.text.isEmpty ||
                          _postalcodeController.text.isEmpty ||
                          _telpController.text.isEmpty ||
                          _mySelection.isEmpty ||
                          _mySelection2.isEmpty ||
                          _mySelection3.isEmpty ||
                          _mySelectionProv.isEmpty) {
                        _validate = false;
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: new Text("Terjadi Kesalahan"),
                              content: new Text("Masih ada data yang kosong !"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new FlatButton(
                                  child: new Text("Tutup"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        if (args != null) {
                          print(globalBaseUrl2 +
                              "api/address/update/" +
                              args["id"].toString());
                          print(tokenFixed);
                          Response response = await http.post(
                              globalBaseUrl2 +
                                  "api/address/update/" +
                                  args["id"].toString(),
                              headers: {
                                "Accept": "application/json",
                                "Authorization": "Bearer " +
                                    (tokenFixed != null ? tokenFixed : ''),
                              },
                              body: body);
                          print(response.statusCode);
                        } else {
                          print(globalBaseUrl2 + "api/address/create");
                          print(tokenFixed);
                          print(body);

                          Response response = await http.post(
                              globalBaseUrl2 + "api/address/create",
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
                    child: Text(
                      'SIMPAN ALAMAT',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                  ))),
        ),
        body: WillPopScope(
          child: AlamatTransaksi(),
          onWillPop: () async {
            setState(() {
              _mySelection = null;
              _mySelection2 = null;
              _mySelection3 = null;
              _mySelectionProv = null;
              dataEdit = null;
              _alamatController.text = null;
              _namaController.text = null;
              _namapenerimaController.text = null;
              _postalcodeController.text = null;
              _telpController.text = null;
            });

            return true;
          },
        ));
  }
}
// end stack end

class AlamatTransaksi extends StatefulWidget {
  @override
  _AlamatTransaksiState createState() => _AlamatTransaksiState();
}

String _mySelection;
String _mySelection2;
String _mySelection3;
String _mySelectionProv;

//Konten Input goes here
class _AlamatTransaksiState extends State<AlamatTransaksi> {
  @override
  void initState() {
    if (this.mounted) {
      setState(() {
        _mySelection = null;
        _mySelection2 = null;
        _mySelection3 = null;
        _mySelectionProv = null;
        dataEdit = null;
        _alamatController.text = null;
        _namaController.text = null;
        _namapenerimaController.text = null;
        _postalcodeController.text = null;
        _telpController.text = null;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
      maxLength: 5,
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
      maxLines: 1,
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
//    var _tapPosition;
    //  final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    // void _storePosition(TapDownDetails details) {
    //   _tapPosition = details.globalPosition;
    // }

    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
        height: MediaQuery.of(context).size.height + 100,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Jenis Alamat :",
                    textAlign: TextAlign.left, style: FintnessAppTheme.body1),
                Spacer()
              ],
            ),
            DropdownButton(
              isExpanded: true,
              isDense: true,
              iconSize: 16,
              icon: Icon(Icons.arrow_drop_down),
              items: dataOcc != null
                  ? dataOcc.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(
                          item['name'],
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: item['id'].toString(),
                      );
                    }).toList()
                  : null,
              onChanged: (newVal) async {
                setState(() {
                  _mySelection3 = newVal;
                });
              },
              value: _mySelection3,
            ),
            namapenerimaField,
            telpField,
            alamatField,
            Row(
              children: <Widget>[
                Text(
                  "Provinsi :",
                  textAlign: TextAlign.left,
                  style: FintnessAppTheme.body1,
                ),
                Spacer()
              ],
            ),
            DropdownButton(
              isExpanded: true,
              isDense: true,
              iconSize: 16,
              icon: Icon(Icons.arrow_drop_down),
              items: dataProv != null
                  ? dataProv.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(
                          item['nama'],
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: item['id'].toString(),
                      );
                    }).toList()
                  : null,
              onChanged: (newVal) async {
                setState(() {
                  _mySelectionProv = newVal;
                });
                Response responseKt = await http.get(
                    globalBaseUrl + "api/address/kota?provinsi_id=" + newVal,
                    headers: {
                      "Accept": "application/json",
                      "Authorization":
                          "Bearer " + (tokenFixed != null ? tokenFixed : '')
                    });
                var tempList = await jsonDecode(responseKt.body.toString());
                if (tempList != null) {
                  print(tempList["data"]["city"]);
                  setState(() {
                    dataKota = tempList["data"]["city"];
                  });
                }
                setState(() {
                  _mySelection = null;
                  _mySelection2 = null;
                });
              },
              value: _mySelectionProv,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Kota :",
                  textAlign: TextAlign.left,
                  style: FintnessAppTheme.body1,
                ),
                Spacer()
              ],
            ),
            DropdownButton(
              isExpanded: true,
              isDense: true,
              iconSize: 16,
              icon: Icon(Icons.arrow_drop_down),
              items: dataKota != null
                  ? dataKota.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(
                          item['nama'],
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: item['kota_id'].toString(),
                      );
                    }).toList()
                  : null,
              onChanged: (newVal) async {
                setState(() {
                  _mySelection = newVal;
                });
                Response responseKcm = await http.get(
                    globalBaseUrl + "api/address/kecamatan?kota_id=" + newVal,
                    headers: {
                      "Accept": "application/json",
                      "Authorization":
                          "Bearer " + (tokenFixed != null ? tokenFixed : '')
                    });
                var tempList = await jsonDecode(responseKcm.body.toString());
                print(tempList["data"]["district"]);
                setState(() {
                  dataKecamatan = tempList["data"]["district"];
                });
                setState(() {
                  _mySelection2 = null;
                });
              },
              value: _mySelection,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Kecamatan :",
                  textAlign: TextAlign.left,
                  style: FintnessAppTheme.body1,
                ),
                Spacer()
              ],
            ),
            DropdownButton(
              isExpanded: true,
              isDense: true,
              iconSize: 16,
              icon: Icon(Icons.arrow_drop_down),
              items: dataKecamatan != null
                  ? dataKecamatan.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(
                          item['nama'].toString() != null
                              ? item['nama'].toString()
                              : null,
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: item['id'].toString() != null
                            ? item['id'].toString()
                            : null,
                      );
                    }).toList()
                  : null,
              onChanged: (newVal) {
                setState(() {
                  _mySelection2 = newVal;
                });
              },
              value: _mySelection2,
            ),
            postalcodeField,
          ],
        ),
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
