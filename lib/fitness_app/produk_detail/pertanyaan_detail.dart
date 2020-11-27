import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tokoterserah/Constant/MathModify.dart';

class PertanyaanDetail extends StatefulWidget {
  final List<dynamic> dataQna;

  const PertanyaanDetail({Key key, this.animationController, this.dataQna})
      : super(key: key);

  final AnimationController animationController;
  @override
  _PertanyaanDetailState createState() => _PertanyaanDetailState();
}

class _PertanyaanDetailState extends State<PertanyaanDetail> {


  @override
  void initState() {
    // TODO: implement initState
    print(widget.dataQna);
    super.initState();
  }

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
          title: Text(
            'Pertanyaan ',
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
        body: Container(
            child: PertanyaanProduk(
          dataQnA: widget.dataQna,
        )));
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
  final List<dynamic> dataQnA;

  PertanyaanProduk({
    Key key,
    /*@required*/
    this.dataQnA,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: dataQnA.length == null ? 0 : dataQnA.length,
          itemBuilder: (context, i) {
            return kontenQna(i);
          }),
    );
  }

  Widget kontenQna(i) {
    return Column(
      children: [
        cardPertanyaan(
            '${dataQnA[i]['user'] ?? '******'}',
            '${diffForhumans(DateTime.parse(dataQnA[i]['created_at']))}',
            '${dataQnA[i]['tanya']}'),
        jawabanQna(i)
      ],
    );
  }

  Widget jawabanQna(i) {
    if (dataQnA[i]['jawab'] != null) {
      return Container(
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
                    'Toko Tersrah',
                    '${diffForhumans(DateTime.parse(dataQnA[i]['updated_at']))}',
                    '${dataQnA[i]['jawab']}',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
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
