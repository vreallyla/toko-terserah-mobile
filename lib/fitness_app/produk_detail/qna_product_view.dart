import 'package:best_flutter_ui_templates/fitness_app/produk_detail/product_detail2.dart';
import 'package:flutter/material.dart';

import 'CustomShowDialog.dart';

class QnAProductView extends StatelessWidget {
  final List<dynamic> dataQnA;

  QnAProductView({
    Key key,
    /*@required*/
    this.dataQnA,
  }) : super(key: key);

    void showAlertDialog(BuildContext context) {
    TextEditingController _emailController = new TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final emailField = TextFormField(
          maxLines: 5,
          controller: _emailController,
          keyboardType: TextInputType.multiline,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Pertanyaan',
            labelText: 'Ajukan Pertanyaan Anda :',
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
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height / 3,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                emailField,
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
                              'Ajukan',
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.only(left: 15, right: 15),
      width: size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //judul
          Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 15),
            child: Row(
              children: [
                Container(
                  width: size.width / 3 * 2 - 15,
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        'Pertanyaan',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '  (1100)',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigate to the second screen using a named route.
                    Navigator.pushNamed(context, '/pertanyaandetail');
                  },
                  child: Container(
                    width: size.width / 3 - 15,
                    alignment: Alignment.centerRight,
                    child: Text('Lihat Semua',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ],
            ),
          ),
          //konten
          cardPertanyaan('Fahmi', '1 bulan lalu', 'hello ?'),
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: borderLeftPertanyaan(),
                  padding: EdgeInsets.only(
                    left: 15,
                  ),
                  margin: EdgeInsets.only(
                    top: 10,
                    left: 15,
                  ),
                  child: Column(
                    children: <Widget>[
                      cardPertanyaan(
                        'Dani',
                        '1 minggu lalu',
                        'iyaaaa',
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            '2 jawaban lain',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),

          //ajukan pertanyaan
          InkWell(
            onTap: () {
              showAlertDialog(context);
            },
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(top: 15, bottom: 15),
              decoration: borderTop(),
              child: Text(
                'Ajukan Pertanyaan',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container cardPertanyaan(String nama, String tanggal, String konten) {
  return Container(
    padding: EdgeInsets.only(bottom: 10),
    child: Column(children: <Widget>[
      Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: new BoxDecoration(
                color: Colors.grey,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0),
                  bottomRight: const Radius.circular(40.0),
                  bottomLeft: const Radius.circular(40.0),
                )),
          ),
          Text(
            '  ' + nama + ' · ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            tanggal,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
      Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(top: 10, left: 50),
        child: Text(
          konten,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    ]),
  );
}


BoxDecoration borderLeftPertanyaan() {
  return BoxDecoration(
    border: Border(
      left: BorderSide(width: 2, color: Colors.black26),
    ),
    color: Colors.white,
  );
}


}