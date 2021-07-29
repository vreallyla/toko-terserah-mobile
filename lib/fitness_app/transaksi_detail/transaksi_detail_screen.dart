import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expandable/expandable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:async/async.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:tokoterserah/Constant/Constant.dart';
import 'package:tokoterserah/fitness_app/cart_list/cart_list.dart';
import 'invoice.dart';

class TransaksiDetailScreen extends StatefulWidget {
  const TransaksiDetailScreen({Key key, this.dashboardId, this.status})
      : super(key: key);

  final String dashboardId;
  final String status;
  @override
  _TransaksiDetailScreenState createState() => _TransaksiDetailScreenState();
}

class _TransaksiDetailScreenState extends State<TransaksiDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _token;

  bool isLoading = true, isConnect = true;

  TextEditingController _ulasanController = new TextEditingController();

  double _star = 3.0;

  var _data;

  final picker = ImagePicker();
  File _image;

  Future _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(_token);
    setState(() {
      _token = prefs.getString('token');
    });
  }

  _getData() async {
    try {
      if (_token != null) {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          var response = await http.get(
              globalBaseUrl + 'api/dashboard/detail/' + widget.dashboardId,
              headers: {"Authorization": "Bearer " + _token});
          var _response = json.decode(response.body);
          _data = _response;
          print(_response);
        }
        setState(() {
          isLoading = false;
        });
        if (_data['data']['tgl_diterima'] != null) {
          if (_data['data']['is_reviewed'] == 0) {
            _showModalReview(context);
          }
        }
      }
    } on SocketException catch (_) {
      isConnect = false;
      isLoading = false;
      setState(() {});
    }
  }

  /**
   * Cutom Alert response
   * 
   */
  showSnackBar(String value, Color color, icons) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Row(
        children: <Widget>[
          icons,
          SizedBox(
            width: 20,
          ),
          Flexible(
              child: Text(
            value,
            maxLines: 2,
          ))
        ],
      ),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ));
  }

/**
   * Confirm 
   * 
   */
  confirm(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text("Apakah Anda Telah Menerima Pesanan Anda ?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Ya",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();

                _barangDiAmbil();
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

  /**
   * Confirm reorder
   * 
   */
  reorder(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text(
              "Apakah Anda yakin akan memesan ulang semua produk yang ada di pesanan ini ?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Ya",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();

                _pesanLagi(context);
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

  /**
   * Confirm reorder
   * 
   */
  checkout(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text("Apakah Anda ingin checkout sekarang?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Ya",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                MaterialPageRoute(
                  builder: (context) => CartList(),
                );
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

  _barangDiAmbil() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await http.post(
            globalBaseUrl + 'api/dashboard/received/' + widget.dashboardId,
            headers: {"Authorization": "Bearer " + _token});
        var _response = json.decode(response.body);
        showSnackBar(_response['data']['message'], Colors.green,
            Icon(Icons.check_circle_outline));
        setState(() {
          isLoading = true;
        });
        _getData();
      }
    } catch (e) {
      print(e);
    }
  }

  _pesanLagi(context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await http.post(
            globalBaseUrl + 'api/dashboard/reorder/' + widget.dashboardId,
            headers: {"Authorization": "Bearer " + _token});
        var _response = json.decode(response.body);

        showSnackBar(_response['data']['message'], Colors.green,
            Icon(Icons.check_circle_outline));
        setState(() {
          isLoading = true;
        });
        _getData();
      }
    } catch (e) {
      print(e);
    }
  }

  _checkReview() async {
    _showModalReview(context);
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
        setState(() {
          _image = File(pickedFile.path);
          // _ulasanController.text = path.basename(_image.path).toString();
        });
        _showModalReview(context);
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
        // _showPicker(context);
      } else {
        print('No image selected.');
      }
    });
  }

  /**
   * Upload Avatar with multipart http 
   */
  uploadImage() async {
    print("Hallo");
    try {
      print("object");
      var stream =
          new http.ByteStream(DelegatingStream.typed(_image.openRead()));
      var length = await _image.length();
      var uri = Uri.parse(
        globalBaseUrl + "api/product/review/image",
      );

      var request = new http.MultipartRequest("POST", uri);

      var multipart = new http.MultipartFile("gambar", stream, length,
          filename: path.basename(_image.path));
      request.headers.addAll({'Authorization': 'bearer ' + _token});
      //Field yang dikirimkan

      // request.fields
      //     .addAll({"user_id": _data['data']['user']['id'].toString()});

      request.files.add(multipart);

      var response = await request.send();
      if (response.statusCode == 200) {
        // showSnackBar("Berhasil Memperbarui Profil", Colors.green,
        //     Icon(Icons.check_circle_outline));
        // setState(() {
        //   isLoading = true;
        // });

        // _getCountCart();
      }
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }

/**
 * Submit Review 
 * 
 */
  _submitReview() async {
    print(jsonEncode(_data['data']['keranjang_ids']));
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (_image != null) {
          await uploadImage();
        }

        var response =
            await http.post(globalBaseUrl + 'api/product/review', headers: {
          "Authorization": "Bearer " + _token,
        }, body: {
          "uni_code": widget.dashboardId,
          "bintang": _star.toString(),
          "produk_ids": jsonEncode(_data['data']['produk_ids']),
          "user_id": _data['data']['user_id'].toString(),
          "ulasan": _ulasanController.text,
          "gambar": _image == null ? '' : path.basename(_image.path).toString(),
        });
        var _response = json.decode(response.body);
        showSnackBar(_response['data']['message'], Colors.green,
            Icon(Icons.check_circle_outline));
        print(_response['data']['message']);
        setState(() {
          isLoading = true;
        });
        _getData();
      }
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.dashboardId);
    _getToken();
    Future.delayed(Duration(milliseconds: 50), () {
      _getData();
    });

    super.initState();
  }

  void _showModalReview(context) {
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
                            Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                          'Silahkan Beri Ulasan Untuk Pesananmu',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18)),
                                    ),
                                    // RatingBar(
                                    //   initialRating: 3,
                                    //   minRating: 1,
                                    //   direction: Axis.horizontal,
                                    //   allowHalfRating: true,
                                    //   itemCount: 5,
                                    //   itemPadding:
                                    //       EdgeInsets.symmetric(horizontal: 4.0),
                                    //   itemBuilder: (context, _) => Icon(
                                    //     Icons.star,
                                    //     color: Colors.green,
                                    //   ),
                                    //   onRatingUpdate: (rating) {
                                    //     setState(() {
                                    //       _star = rating;
                                    //     });
                                    //     print(rating);
                                    //   },
                                    // ),
                                    SmoothStarRating(
                                      rating: _star,
                                      isReadOnly: false,
                                      size: 30,
                                      filledIconData: Icons.star,
                                      halfFilledIconData: Icons.star_half,
                                      defaultIconData: Icons.star_border,
                                      starCount: 5,
                                      allowHalfRating: true,
                                      spacing: 2.0,
                                      onRated: (value) {
                                        print(
                                            "rating value dd -> ${value.truncate()}");
                                        setState(() {
                                          _star = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: SizedBox(
                                        child: TextField(
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              height: 1,
                                              color: Colors.black),
                                          controller: _ulasanController,
                                          textAlign: TextAlign.start,
                                          maxLines: 4,
                                          maxLength: 250,
                                          decoration: new InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black54,
                                                  width: 1),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black38,
                                                  width: 1),
                                            ),
                                            hintText:
                                                'Tulisakan Ulasan Anda di sini',
                                          ),
                                        ),
                                      ),
                                    ),
                                    _image != null
                                        ? Center(
                                            child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.file(
                                                _image,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                          ))
                                        : Wrap(
                                            children: [
                                              new ListTile(
                                                leading: new Icon(
                                                    Icons.photo_camera),
                                                title:
                                                    new Text('Tambahkan foto'),
                                                onTap: () {
                                                  getImageCamera(context);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                    Container(
                                        color: Colors.white,
                                        padding: EdgeInsets.all(5),
                                        height: 100,
                                        child: Row(
                                          children: [
                                            Spacer(
                                              flex: 1,
                                            ),
                                            RaisedButton(
                                              child: Text(
                                                'Submit',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              color: Colors.green,
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _submitReview();
                                              },
                                            ),
                                            Spacer(
                                              flex: 1,
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Wrap(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                          'Silahkan Beri Ulasan Untuk Pesananmu',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18)),
                                    ),
                                    // RatingBar(
                                    //   initialRating: 3,
                                    //   minRating: 1,
                                    //   direction: Axis.horizontal,
                                    //   allowHalfRating: true,
                                    //   itemCount: 5,
                                    //   itemPadding:
                                    //       EdgeInsets.symmetric(horizontal: 4.0),
                                    //   itemBuilder: (context, _) => Icon(
                                    //     Icons.star,
                                    //     color: Colors.green,
                                    //   ),
                                    //   onRatingUpdate: (rating) {
                                    //     setState(() {
                                    //       _star = rating;
                                    //     });
                                    //     print(rating);
                                    //   },
                                    // ),
                                    SmoothStarRating(
                                      rating: _star,
                                      isReadOnly: false,
                                      size: 30,
                                      filledIconData: Icons.star,
                                      halfFilledIconData: Icons.star_half,
                                      defaultIconData: Icons.star_border,
                                      starCount: 5,
                                      allowHalfRating: true,
                                      spacing: 2.0,
                                      onRated: (value) {
                                        print(
                                            "rating value dd -> ${value.truncate()}");
                                        setState(() {
                                          _star = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: SizedBox(
                                        child: TextField(
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              height: 1,
                                              color: Colors.black),
                                          controller: _ulasanController,
                                          textAlign: TextAlign.start,
                                          maxLines: 4,
                                          maxLength: 250,
                                          decoration: new InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black54,
                                                  width: 1),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black38,
                                                  width: 1),
                                            ),
                                            hintText:
                                                'Tulisakan Ulasan Anda di sini',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Wrap(
                                      children: [
                                        new ListTile(
                                          leading: new Icon(Icons.photo_camera),
                                          title: new Text('Tambahkan foto'),
                                          onTap: () {
                                            getImageCamera(context);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                    Container(
                                        color: Colors.white,
                                        padding: EdgeInsets.all(5),
                                        height: 100,
                                        child: Row(
                                          children: [
                                            Spacer(
                                              flex: 1,
                                            ),
                                            RaisedButton(
                                              child: Text(
                                                'Kirim',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              color: Colors.green,
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _submitReview();
                                              },
                                            ),
                                            Spacer(
                                              flex: 1,
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.grey[200],
        title: const Text(
          'Rincian Pesanan',
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: isLoading
          ? reqLoad()
          : (_data['data']['isAmbil'] == 1
              ? PreferredSize(
                  preferredSize: Size.fromHeight(80.0),
                  child: BottomAppBar(
                      child: Container(
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: RaisedButton(
                            onPressed: () {
                              //Jika Barang Diambil Sendiri
                              if (_data['data']['tgl_diterima'] == null) {
                                confirm(context);
                              } else {
                                reorder(context);
                              }
                            },
                            child: Text(
                              _data['data']['tgl_diterima'] == null
                                  ? 'Tandai Barang Telah Diambil'
                                  : 'PESAN ULANG',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.green,
                          ))),
                )
              : (_data['data']['recent_track'] == null
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(80.0),
                      child: BottomAppBar(
                          child: Container(
                              padding: EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              child: Container(
                                height: 1.0,
                              ))),
                    )
                  : (_data['data']['is_kurir_terserah'] == 1
                      ? PreferredSize(
                          preferredSize: Size.fromHeight(80.0),
                          child: BottomAppBar(
                              child: Container(
                                  padding: EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                  ),
                                  child: RaisedButton(
                                    onPressed: () {
                                      //Jika Barang Sudah dikirim Tapi belum Diterima
                                      confirm(context);
                                    },
                                    child: Text(
                                      'Tandai Barang Telah Diterima',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.green,
                                  ))),
                        )
                      : (_data['data']['tgl_diterima'] == null
                          ? PreferredSize(
                              preferredSize: Size.fromHeight(80.0),
                              child: BottomAppBar(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                      ),
                                      child: RaisedButton(
                                        onPressed: () {
                                          //Jika Barang Sudah dikirim Tapi belum Diterima
                                          confirm(context);
                                        },
                                        child: Text(
                                          'Tandai Barang Telah Diterima',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.green,
                                      ))),
                            )
                          : PreferredSize(
                              preferredSize: Size.fromHeight(80.0),
                              child: BottomAppBar(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                      ),
                                      child: RaisedButton(
                                        onPressed: () {
                                          //Jika barang telah sampai dan sudah diterima
                                          reorder(context);
                                        },
                                        child: Text(
                                          'PESAN ULANG',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.green,
                                      ))),
                            ))))),
      body: isLoading
          ? reqLoad()
          : Container(
              color: Colors.grey[300],
              child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    StatusTransaksi(
                      data: _data,
                      status: widget.status,
                    ),
                    HeadDaftarTransaksi(
                        dataItem: _data['data']['carts'], data: _data),
                    AlamatTransaksi(
                      data: _data['data']['alamat_pengiriman'],
                    ),
                    _data['data']['isLunas'] == 1
                        ? (_data['data']['recent_track'] == null
                            ? Dikemas(
                                status: _data['data']['status'],
                                isAmbil: _data['data']['isAmbil'],
                              )
                            : TrackerTransaksi(
                                dataTracking: _data['data']['full_track'],
                                kurir: _data['data']['kode_kurir'],
                                layanan: _data['data']['layanan_kurir'],
                              ))
                        : Container(),

                    // TransaksiVia(),
                  ]),
            ),
    );
  }
}
// end stack end

class StatusTransaksi extends StatelessWidget {
  final Map<String, dynamic> data;
  final String status;

  const StatusTransaksi({this.data, this.status});

  _launchURL() async {
    const url =
        'https://tokoterserah.com/api/dashboard/invoice/PYM5F9573618F30C1603629921?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvdG9rb3RlcnNlcmFoLmNvbVwvYXBpXC9hdXRoXC9sb2dpbiIsImlhdCI6MTYwMzQyMjY4MywiZXhwIjoxNjA3MDIyNjgzLCJuYmYiOjE2MDM0MjI2ODMsImp0aSI6IkxWTEl5eGhEYXFMY1JaNW4iLCJzdWIiOjEsInBydiI6Ijg3ZTBhZjFlZjlmZDE1ODEyZmRlYzk3MTUzYTE0ZTBiMDQ3NTQ2YWEifQ.llHiUXKS5nFNN0RLp1RfFA5_eqrQ4lTGPDvq_7_HLTE';
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        print('Go to Invoice # ${data['data']['uni_code']}');

        Navigator.push(
            //push screen to check out and send parameter
            context,
            MaterialPageRoute(
              builder: (context) => Invoice(
                code: data['data']['file_invoice'],
              ),
            ));
      },
      // onTap: _launchURL,
      child: Container(
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
                        FontAwesomeIcons.infoCircle,
                        color: Colors.black54,
                        size: 18,
                      ),
                    ),
                    Container(
                        width: size.width / 3,
                        child: Text('Status',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ))),
                    Container(
                      width: size.width / 2,
                      alignment: Alignment.centerRight,
                      child: Text('${status}',
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
                    Container(
                        width: size.width - 30 - 110 - 30,
                        child: Text('${data['data']['uni_code']}')),
                  ]),
            ),
            Container(
              padding: EdgeInsets.only(left: 30, top: 5),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 110,
                      child: Text('Tgl. Diterima'),
                    ),
                    Container(
                        width: size.width - 30 - 110 - 30,
                        child: Text(': ${data['data']['tgl_diterima'] ?? '-'}',
                            maxLines: 2)),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class AlamatTransaksi extends StatelessWidget {
  final Map<String, dynamic> data;

  const AlamatTransaksi({this.data});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      margin: EdgeInsets.only(bottom: 15),
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              child: FaIcon(
                FontAwesomeIcons.locationArrow,
                color: Colors.green,
                size: 18,
              ),
            ),
            Container(
                width: size.width - 30 - 100 - 30,
                child: Text('Alamat',
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
                child: Text('',
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
                    width: size.width - 30 - 30,
                    child: Text(
                      '${data['nama']}',
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
                    width: size.width - 30 - 30,
                    child: Text(
                      '${data['telp']}',
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
                    width: size.width - 30 - 30,
                    child: Text(
                      '${data['alamat']}',
                      maxLines: 4,
                    )),
              ]),
        ),
      ]),
    );
  }
}

class TrackerTransaksi extends StatelessWidget {
  final List dataTracking;
  final String kurir;
  final String layanan;
  const TrackerTransaksi({this.dataTracking, this.kurir, this.layanan});

  @override
  Widget build(BuildContext context) {
    final dateFormat = new DateFormat.yMMMMd('id_ID');
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
                child: Text('',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              ),
            )
          ],
        )),
        Column(
          children: <Widget>[
            ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                reverse: kurir == "jnt" ? true : false,
                itemCount:
                    dataTracking.length == null ? 0 : dataTracking.length,
                itemBuilder: (context, i) {
                  if (kurir != "jnt") {
                    if (i == 0) {
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 15,
                            ),
                            padding: EdgeInsets.only(left: 15, bottom: 15),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    width: 0.5, color: Colors.black54),
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
                                    '${dataTracking[i]['manifest_description']} ${dataTracking[i]['city_name']}',
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
                                  child: Text(
                                      '${kurir.toUpperCase()} ( ${layanan.toUpperCase()} )'),
                                ),
                                Container(
                                  width: size.width - 30 - 30,
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                      '${dateFormat.format(DateTime.parse(dataTracking[i]['manifest_date']))} | ${dataTracking[i]['manifest_time']}',
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
                      );
                    } else {
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 15,
                            ),
                            padding: EdgeInsets.only(left: 15, bottom: 15),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    width: 0.5, color: Colors.black54),
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
                                    '${dataTracking[i]['manifest_description']} ${dataTracking[i]['city_name']}',
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                    maxLines: 2,
                                  ),
                                ),
                                Container(
                                  width: size.width - 30 - 30,
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    '${kurir.toUpperCase()} ( ${layanan.toUpperCase()} )',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ),
                                Container(
                                  width: size.width - 30 - 30,
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                      '${dateFormat.format(DateTime.parse(dataTracking[i]['manifest_date']))} | ${dataTracking[i]['manifest_time']}',
                                      style:
                                          TextStyle(color: Colors.grey[500])),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10, left: 10.5),
                              decoration: BoxDecoration(
                                color: Colors.grey[500],
                              ),
                              height: 10,
                              width: 10),
                        ],
                      );
                    }
                  } else {
                    if (i == dataTracking.length - 1 ) {
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 15,
                            ),
                            padding: EdgeInsets.only(left: 15, bottom: 15),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    width: 0.5, color: Colors.black54),
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
                                    '${dataTracking[i]['manifest_description']} ${dataTracking[i]['city_name']}',
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
                                  child: Text(
                                      '${kurir.toUpperCase()} ( ${layanan.toUpperCase()} )'),
                                ),
                                Container(
                                  width: size.width - 30 - 30,
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                      '${dateFormat.format(DateTime.parse(dataTracking[i]['manifest_date']))} | ${dataTracking[i]['manifest_time']}',
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
                      );
                    } else {
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 15,
                            ),
                            padding: EdgeInsets.only(left: 15, bottom: 15),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    width: 0.5, color: Colors.black54),
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
                                    '${dataTracking[i]['manifest_description']} ${dataTracking[i]['city_name']}',
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                    maxLines: 2,
                                  ),
                                ),
                                Container(
                                  width: size.width - 30 - 30,
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    '${kurir.toUpperCase()} ( ${layanan.toUpperCase()} )',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ),
                                Container(
                                  width: size.width - 30 - 30,
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                      '${dateFormat.format(DateTime.parse(dataTracking[i]['manifest_date']))} | ${dataTracking[i]['manifest_time']}',
                                      style:
                                          TextStyle(color: Colors.grey[500])),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10, left: 10.5),
                              decoration: BoxDecoration(
                                color: Colors.grey[500],
                              ),
                              height: 10,
                              width: 10),
                        ],
                      );
                    }
                  }
                }),
          ],
        )
      ]),
    );
  }
}

class HeadDaftarTransaksi extends StatelessWidget {
  final Map<String, dynamic> data;
  final List dataItem;
  const HeadDaftarTransaksi({this.dataItem, this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formatter = new NumberFormat("#,###.00", 'id_ID');
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
                    child: Text('Daftar Pesanan (${dataItem.length} item)',
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
                  ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataItem.length == null ? 0 : dataItem.length,
                      itemBuilder: (context, i) {
                        return Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 70,
                                  height: 70,
                                  margin: EdgeInsets.only(right: 10),
                                  color: Colors.grey,
                                  child: FadeInImage(
                                      placeholder: NetworkImage(
                                          'https://tokoterserah.com/storage/produk/thumb/placeholder.jpg'),
                                      image: NetworkImage(
                                          'https://tokoterserah.com/storage/produk/thumb/' +
                                              '${dataItem[i]['produk']['gambar']}'))),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(top: 7),
                                    width: size.width - 60 - 80,
                                    child: Text(
                                      '${dataItem[i]['produk']['nama']}',
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
                                      'X ${dataItem[i]['qty']}',
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
                                        // Text(
                                        //   '(Rp500.000,-)',
                                        //   style: TextStyle(
                                        //     fontSize: 12,
                                        //     fontWeight: FontWeight.w500,
                                        //     color: Colors.black54,
                                        //     decoration:
                                        //         TextDecoration.lineThrough,
                                        //   ),
                                        // ),
                                        Text(
                                          '  Rp ${formatter.format(int.parse(dataItem[i]['total']))}',
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
                        );
                      })
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
                          child: Text(
                              'Rp${formatter.format(data['data']['subtotal'])}',
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
                          child: Text(
                              'Rp${formatter.format(double.parse(data['data']['ongkir']))}',
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
                          child: Text(
                              'Rp${formatter.format(double.parse(data['data']['discount'] ?? '0'))}',
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
                          child: Text(
                              'Rp${formatter.format(double.parse(data['data']['ongkir']) + data['data']['subtotal'] - double.parse(data['data']['discount'] ?? '0'))}',
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

class Dikemas extends StatelessWidget {
  final String status;
  final int isAmbil;
  const Dikemas({this.status, this.isAmbil});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return isAmbil == 1
        ? Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            margin: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.5, color: Colors.black26),
              ),
              color: Colors.white,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      child: Text('',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
                  )
                ],
              )),
              Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 15,
                        ),
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
                                '${status}',
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
                              child: Text(
                                isAmbil == 1 ? 'Ambil di Toko Terserah' : '',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                            Container(
                              width: size.width - 30 - 30,
                              padding: EdgeInsets.only(top: 5),
                              child: Text(isAmbil == 1 ? 'Hari ini' : '',
                                  style: TextStyle(color: Colors.green)),
                            )
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10, left: 10.5),
                          decoration: BoxDecoration(
                            color: Colors.green,
                          ),
                          height: 10,
                          width: 10),
                    ],
                  )
                ],
              )
            ]),
          )
        : Container();
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
