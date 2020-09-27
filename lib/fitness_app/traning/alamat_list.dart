import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expandable/expandable.dart';
import '../produk_detail/CustomShowDialog.dart';

class AlamatList extends StatefulWidget {
  @override
  _AlamatListState createState() => _AlamatListState();
}

void showAlertDialog(BuildContext context) {
  TextEditingController _namaController = new TextEditingController();
  TextEditingController _namapenerimaController = new TextEditingController();
  TextEditingController _alamatController = new TextEditingController();
  TextEditingController _telpController = new TextEditingController();
  TextEditingController _postalcodeController = new TextEditingController();

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
        ),
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
        ),
      );

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
        ),
      );
      final alamatField = TextFormField(
        maxLines: 4,
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
        ),
      );

      return CustomAlertDialog(
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.6,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              namaField,
              namapenerimaField,
              telpField,
              alamatField,
              postalcodeField,
              MaterialButton(
                onPressed: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 12,
                  padding: EdgeInsets.all(15.0),
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
          'List Alamat',
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: BottomAppBar(
            child: Container(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: RaisedButton(
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  child: Text(
                    'Tambah alamat',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                ))),
      ),
      body: Container(
        color: Colors.grey[300],
        child: ListView(children: <Widget>[
          //StatusTransaksi(),
          alamatTransaksi(),
          alamatTransaksi(),
          alamatTransaksi(),
          //rackerTransaksi(),
          // HeadDaftarTransaksi(),
          //TransaksiVia(),
        ]),
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

class alamatTransaksi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
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
                child: Text('Alamat Rumah',
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
                child: Text('Salin',
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
                      'Fahmi Rizky Maulidy',
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
                      '(+62) 081553847015',
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
                      'Jl. Menanggal no. 4, Menanggal, Surabaya',
                      maxLines: 4,
                    )),
              ]),
        ),
      ]),
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
