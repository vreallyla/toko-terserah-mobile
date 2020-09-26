import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class PertanyaanDetail extends StatefulWidget {
  const PertanyaanDetail({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _PertanyaanDetailState createState() => _PertanyaanDetailState();
}

class _PertanyaanDetailState extends State<PertanyaanDetail> {
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
            'Pertanyaan',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.notifications),
            //   onPressed: () {},
            //   color: Colors.black,
            // )
          ],
        ),
        body: Container(child: PertanyaanProduk()));
  }
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

class PertanyaanProduk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.only(left: 15, right: 15), children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      cardPertanyaan(
                        'Deni',
                        '1 hari lalu',
                        'tes',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                      cardPertanyaan(
                        'Deni',
                        '1 hari lalu',
                        'tes',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                      cardPertanyaan(
                        'Deni',
                        '1 hari lalu',
                        'tes',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                      cardPertanyaan(
                        'Deni',
                        '1 hari lalu',
                        'tes',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    ]);
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

BoxDecoration borderLeftPertanyaan() {
  return BoxDecoration(
    border: Border(
      left: BorderSide(width: 2, color: Colors.black26),
    ),
    color: Colors.white,
  );
}

BoxDecoration borderRight() {
  return BoxDecoration(
    border: Border(
      right: BorderSide(width: 0.5, color: Colors.black26),
    ),
    color: Colors.white,
  );
}
// end stack end
