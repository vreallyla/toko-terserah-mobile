import 'package:flutter/material.dart';

class VoucherKuponScreen extends StatefulWidget {
  const VoucherKuponScreen({Key key, this.animationController})
      : super(key: key);

  final AnimationController animationController;
  @override
  _VoucherKuponScreenState createState() => _VoucherKuponScreenState();
}

class _VoucherKuponScreenState extends State<VoucherKuponScreen> {
  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Voucher',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[cardSearch(), titleVoucher(), cartKupon()],
        ),
      ),
    );
  }
}

class cardSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      height: 100,
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          //background color of box
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.5, // soften the shadow
            spreadRadius: .5, //extend the shadow
            offset: Offset(
              .5, // Move to right 10  horizontally
              .5, // Move to bottom 10 Vertically
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Punya kode voucher? masukan di sini',
                  style: TextStyle(color: Colors.black54))),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: sizeu.width - 80 - 40 - 5,
                height: 40,
                child: TextField(
                  textAlign: TextAlign.left,
                  onChanged: (text) => {},
                  decoration: new InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1),
                    ),
                    hintText: 'Masukkan kode voucher',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: SizedBox(
                  height: 40,
                  width: 80,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(4.0),
                        bottomLeft: Radius.circular(4.0),
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    onPressed: () {},
                    color: Colors.green,
                    child: Text(
                      'Cari',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class titleVoucher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: sizeu.width - 180,
            // color: Colors.red,
            child: Text(
              'Pilih Voucher',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: 140,
            child: Text(
              '(1 voucher)',
              style: TextStyle(color: Colors.black54),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}

class cartKupon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
      height: sizeu.width / 5 + 40,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        boxShadow: [
          //background color of box
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.5, // soften the shadow
            spreadRadius: .5, //extend the shadow
            offset: Offset(
              .5, // Move to right 10  horizontally
              .5, // Move to bottom 10 Vertically
            ),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: sizeu.width / 5,
            height: sizeu.width / 5,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),

            margin: EdgeInsets.only(right: 10),
            child: Center(
              child: Text(
                'KLAIM',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            // child: Image(image: AssetImage('assets/fitness_app/logo.png')),
          ),
          Container(
            width: sizeu.width - 40 - 30 - sizeu.width / 5 - 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  // width: sizeu.width - 40 - 30 - 160,
                  child: Text(
                    'SEMOGABERKAH',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  // width: 160,
                  // alignment: Alignment.topRight,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Text(
                      //   'Potongan : ',
                      //   style: TextStyle(fontSize: 12, color: Colors.black54),
                      // ),
                      Text(
                        '-Rp150.000',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'loremß epsum dolor siamet Lorem epsum dolor siamet  Lorem epsum dolor siamet Lorem epsum dolor siamet Lorem epsum dolor siamet  ',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                    maxLines: 2,
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.only(top: 10),
                //   child: Text(
                //     'Klaim',
                //     overflow: TextOverflow.ellipsis,
                //     textAlign: TextAlign.justify,
                //     style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 15),

                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// end stack end
