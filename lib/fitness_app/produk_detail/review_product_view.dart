import 'package:best_flutter_ui_templates/Controllers/harga_controller.dart';
import 'package:flutter/material.dart';

class ReviewProductView extends StatefulWidget {
  final Map<String, dynamic> dataReview;

  ReviewProductView({
    Key key,
    /*@required*/
    this.dataReview,
  }) : super(key: key);

  @override
  _ReviewProductViewState createState() => _ReviewProductViewState();
}

class _ReviewProductViewState extends State<ReviewProductView> {
  List<Widget> listViews = [];

  void addAllListData(context) {
    var size = MediaQuery.of(context).size;
    listViews = [];

    //judul
    listViews.add(
      Container(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 8),
        child: Row(
          children: [
            Container(
              width: size.width / 2 - 15,
              alignment: Alignment.topLeft,
              child: Text('Ulasan Produk',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            InkWell(
              onTap: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, '/ulasandetail');
              },
              child: Container(
                width: size.width / 2 - 15,
                alignment: Alignment.centerRight,
                child: Text('Lihat Semua',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            )
          ],
        ),
      ),
    );
    //bintang
    listViews.add(
      Container(
        width: size.width,
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: Row(
          children: <Widget>[
            Text(decimalPointOne(widget.dataReview['avg']),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
            Text(' / 5.0 ',
                style: TextStyle(
                  fontSize: 16,
                )),
            Icon(
              Icons.star,
              size: 18,
              color: Colors.green,
            ),
            Text('  (11 Ulasan)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                )),
          ],
        ),
      ),
    );
    //gambar ulasan
    listViews.add(
      Container(
        width: size.width,
        padding: EdgeInsets.fromLTRB(11, 0, 11, 15),
        child: Row(
          children: <Widget>[
            gambarReview(context),
            gambarReview(context),
            gambarReview(context),
            gambarReviewlengkap(context),
          ],
        ),
      ),
    );
//ulasan top
    listViews.add(Container(
      width: size.width,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 10),
          alignment: Alignment.bottomLeft,
          child: Text(
            'Ulasan Unggulan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.star,
              size: 25,
              color: Colors.green,
            ),
            Icon(
              Icons.star,
              size: 25,
              color: Colors.green,
            ),
            Icon(
              Icons.star,
              size: 25,
              color: Colors.green,
            ),
            Icon(
              Icons.star,
              size: 25,
              color: Colors.green,
            ),
            Icon(
              Icons.star,
              size: 25,
              color: Colors.green,
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.bottomLeft,
          child: Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse tristique, erat sed mollis tincidunt, sapien leo lobortis quam, sed finibus tortor metus a dolor. Maecenas et ligula nibh. Suspendisse elit turpis, bibendum vitae consectetur condimentum, sollicitudin sed eros. Curabitur viverra bibendum massa, ac tincidunt arcu gravida ut.',
            style: TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.justify,
            maxLines: 4,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 15),
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              Text(
                '1 bulan lalu dibuat oleh ',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                'Fahmi',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ]),
    ));

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    addAllListData(context);

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      width: size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listViews,
      ),
    );
  }

  Container gambarReview(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(left: 4, right: 4),
      child: Flexible(
        flex: 1,
        child: Container(
          alignment: Alignment.center,
          width: (size.width - 58) / 4,
          height: (size.width - 58) / 4,
          color: Colors.black26,
          child: Text(
            'Gambar',
            style: TextStyle(fontSize: 11),
          ),
        ),
      ),
    );
  }

  Container gambarReviewlengkap(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        padding: EdgeInsets.only(left: 4, right: 4),
        child: InkWell(
          onTap: () {
            // Navigate to the second screen using a named route.
            Navigator.pushNamed(context, '/gambarulasan');
          },
          child: Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              width: (size.width - 58) / 4,
              height: (size.width - 58) / 4,
              color: Colors.black26,
              child: Text(
                'Selengkapnya',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
        ));
  }
}
