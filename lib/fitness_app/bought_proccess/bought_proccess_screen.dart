import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BoughtProccessScreen extends StatefulWidget {
  const BoughtProccessScreen({Key key, this.animationController})
      : super(key: key);

  final AnimationController animationController;
  @override
  _BoughtProccessScreenState createState() => _BoughtProccessScreenState();
}

class _BoughtProccessScreenState extends State<BoughtProccessScreen> {
  @override
  Widget build(BuildContext context) {
    Color kMainColor = Colors.black54;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.grey[200],
          title: const Text(
            'Daftar Transaksi',
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            labelStyle:
                TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
            labelColor: Colors.green,
            unselectedLabelColor: kMainColor,
            //  indicator: ShapeDecoration(
            //    shape: StadiumBorder(side: BorderSide(width: 5.0, color: kMainColor))
            //   //  shape: RoundedRectangleBorder(
            //   //    side: BorderSide(width: 5.0, color: kMainColor),
            //   //    borderRadius: BorderRadius.circular(20),
            //   //  )
            //  ),
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.green, width: 3.0)),
            // indicator: CircleTabIndicator(color: Colors.green, radius: 3),
            //  indicator: BoxDecoration(
            //    color: kMainColor,
            //    borderRadius: BorderRadius.circular(20),
            //  ),
            tabs: <Widget>[
              Tab(child: judulTab('Belum Bayar')),
              Tab(child: judulTab('Dikemas')),
              Tab(child: judulTab('Dikirim')),
              Tab(child: judulTab('Selesai')),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Container(
              color: Colors.grey.withOpacity(.4),
              child: ListView(
                children: [
                  cardBought(
                      MediaQuery.of(context).size,
                      'inv/01/2020/08',
                      'barang dicoba',
                      '20 Sept 2020',
                      '3',
                      '30.000,-',
                      'belum bayar',
                      context),
                ],
              ),
            ),
            Container(
              color: Colors.grey.withOpacity(.4),
              child: ListView(
                children: [
                  cardBought(
                      MediaQuery.of(context).size,
                      'inv/01/2020/08',
                      'barang dicoba 2',
                      '20 Sept 2020',
                      '3',
                      '40.000,-',
                      'dikemas',
                      context),
                ],
              ),
            ),
            Container(
              color: Colors.grey.withOpacity(.4),
              child: ListView(
                children: [
                  cardBought(
                      MediaQuery.of(context).size,
                      'inv/01/2020/08',
                      'barang dicoba 3',
                      '20 Sept 2020',
                      '3',
                      '30.000,-',
                      'dikirim',
                      context),
                ],
              ),
            ),
            Container(
              color: Colors.grey.withOpacity(.4),
              child: ListView(
                children: [
                  cardBought(
                      MediaQuery.of(context).size,
                      'inv/01/2020/08',
                      'barang dicoba 4',
                      '20 Sept 2020',
                      '3',
                      '30.000,-',
                      'selesai',
                      context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget judulTab(String judul) {
  return Center(child: Text(judul, style: TextStyle(fontSize: 12)));
}

Widget tagCard(
  String judul,
  final sizeu,
  String tanggal,
  String inv,
  String jmlhPlus,
  final context,
) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, '/transaksi_detail');
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 30,
          alignment: Alignment.center,
          width: sizeu.width - 30,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(.3),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: Text(
            judul,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: sizeu.width - 30,
                  padding: EdgeInsets.only(left: 10, right: 10, top: 7),
                  child: Text(
                    tanggal,
                    style: TextStyle(color: Colors.black54),
                  )),
              Container(
                  width: sizeu.width - 30,
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 7),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: .5, color: Colors.black26),
                    ),
                  ),
                  child: Text(
                    inv,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )),
            ],
          ),
        ),
        Container(
          width: sizeu.width - 30,
          height: 105,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: .5, color: Colors.black26),
            ),
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(width: 70, height: 70, color: Colors.grey),
                Container(
                    padding: EdgeInsets.only(left: 5, right: 10),
                    width: sizeu.width - 30 - 20 - 70 - 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          judul,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            '(+ $jmlhPlus Produk Lainnya)',
                            style:
                                TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                        )
                      ],
                    ))
              ]),
        )
      ],
    ),
  );
}

Widget trackCard(final sizeu) {
  return InkWell(
    onTap: () {},
    child: Container(
      width: sizeu.width - 30,
      height: 35,
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: .5, color: Colors.black26),
        ),
      ),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Container(
          width: sizeu.width - 30 - 20 - 20,
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.truck,
                color: Colors.green[800],
                size: 16,
              ),
              Text(
                ' [lokasi akhir disini]',
                style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          width: 20,
          child: Icon(
            Icons.arrow_forward_ios,
            size: 15,
          ),
        )
      ]),
    ),
  );
}

Container totalCard(final sizeu, String total, bool rating) {
  List dataFooter = <Widget>[];

  dataFooter.add(
    Container(
      width: sizeu.width - 30 - 95 - 100,
      // color: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Pembayaran',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          Text(
            'Rp' + total,
            style: TextStyle(
                fontSize: 18,
                color: Colors.green[800],
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );

  if (rating) {
    dataFooter.add(Container(
      width: 100,
      child: RaisedButton(
        onPressed: () {},
        color: Colors.green,
        child: Text(
          'Nilai',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    ));
  }

  return Container(
    width: sizeu.width - 30,
    padding: EdgeInsets.only(left: 85, right: 10, top: 10),
    child: Row(
      children: dataFooter,
    ),
  );
}

Container cardBought(final sizeu, String inv, String judul, String tanggal,
    String jmlhPlus, String total, String jenis, final context) {
  String tagTab;
  double hei;
  List dataCard = <Widget>[];

  switch (jenis) {
    case 'belum bayar':
      {
        tagTab = 'Menunggu Pembayaran';
        hei = 250;
        dataCard.add(tagCard(tagTab, sizeu, tanggal, inv, jmlhPlus, context));

        dataCard.add(totalCard(sizeu, total, false));

        // statements;
      }
      break;

    case 'dikemas':
      {
        tagTab = 'Pesanan Sedang Disiapkan';
        hei = 280;
        dataCard.add(tagCard(tagTab, sizeu, tanggal, inv, jmlhPlus, context));

        dataCard.add(trackCard(sizeu));
        dataCard.add(totalCard(sizeu, total, false));
        //statements;
      }
      break;
    case 'dikirim':
      {
        //statements;
        tagTab = 'Pesanan Sedang Dikirim';
        hei = 280;
        dataCard.add(tagCard(tagTab, sizeu, tanggal, inv, jmlhPlus, context));

        dataCard.add(trackCard(sizeu));
        dataCard.add(totalCard(sizeu, total, false));
      }
      break;
    case 'selesai':
      {
        //statements;
        tagTab = 'Pesanan Telah Selesai';
        hei = hei = 250;
        dataCard.add(tagCard(tagTab, sizeu, tanggal, inv, jmlhPlus, context));

        dataCard.add(totalCard(sizeu, total, true));
      }
      break;

    default:
      {
        //statements;
      }
      break;
  }

  return Container(
    height: hei,
    margin: EdgeInsets.only(top: 15, left: 15, right: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(5),
        bottomLeft: Radius.circular(5),
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.black54,
            // offset: const Offset(1.1, 1.1),
            blurRadius: 2.0),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dataCard,
    ),
  );
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius - 5);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
