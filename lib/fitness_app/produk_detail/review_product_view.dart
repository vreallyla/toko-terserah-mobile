import 'package:tokoterserah/Controllers/harga_controller.dart';
import 'package:flutter/material.dart';
import 'package:tokoterserah/Constant/MathModify.dart';
import 'ulasan_detail.dart' as ulasan;
import 'package:cached_network_image/cached_network_image.dart';

class ReviewProductView extends StatefulWidget {
  final Map<String, dynamic> dataReview;
  final List listReview;
  ReviewProductView(
      {Key key,
      /*@required*/
      this.dataReview,
      this.listReview})
      : super(key: key);

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
            inkwellUlasan(context, size)
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
            Text('  (${widget.dataReview['count']} Ulasan)',
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
            SizedBox(
              height: 84.0,
              child: ListView.builder(
                  itemCount: widget.listReview == null
                      ? 0
                      : (widget.listReview.length > 4
                          ? 4
                          : widget.listReview.length),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, i) {
                    return widget.listReview[i]['gambar'] == null
                        ? Container()
                        : (widget.listReview[i]['gambar'] == ""
                            ? Container()
                            : Container(
                                alignment: Alignment.center,
                                width: 100,
                                height: 100,
                                // color: Colors.black26,

                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://tokoterserah.com/storage/produk/ulasan/' +
                                          widget.listReview[i]['gambar'],
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )));

                    //  gambarReview(
                    //     context, widget.listReview[i]['gambar'])

                    //     );
                  }),
            ),
            // gambarReview(context),
            // gambarReviewlengkap(context),
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
        starJadi(double.parse(widget.dataReview['data']['bintang']),
            widget.dataReview['data']['bintang']),
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.bottomLeft,
          child: Text(
            '${widget.dataReview['data']['deskripsi']}',
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
                diffForhumans(
                    DateTime.parse(widget.dataReview['data']['updated_at'])),
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                '${widget.dataReview['data']['get_user']['name']}',
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

  Icon iconStar() {
    return Icon(
      Icons.star,
      color: Colors.green,
      size: 18,
    );
  }

  Icon iconStarSetengah() {
    return Icon(
      Icons.star_half,
      color: Colors.green,
      size: 18,
    );
  }

  Icon iconStarKosong() {
    return Icon(
      Icons.star_border,
      color: Colors.lightGreen,
      size: 18,
    );
  }

  Container starJadi(double jmlStar, String jlmVote) {
    List dataRown = <Widget>[];

    List.generate(5, (index) {
      dataRown.add(
        Container(
            child: (index + 1) <= jmlStar
                ? iconStar()
                : (index < jmlStar ? iconStarSetengah() : iconStarKosong())),
      );
    });

    dataRown.add(Text(' ($jlmVote)',
        style: TextStyle(fontSize: 12, color: Colors.grey)));

    return Container(
        padding: EdgeInsets.only(top: 3), child: Row(children: dataRown));
  }

  Widget inkwellUlasan(context, size) {
    return InkWell(
      onTap: () {
        // Navigate to the second screen using a named route.
        // Navigator.pushNamed(context, '/ulasandetail');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ulasan.UlasanDetail(
                dataReview: widget.listReview,
              ),
            ));
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
    );
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

  Container gambarReview(BuildContext context, String url_img) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: 100,
      height: 100,
      padding: EdgeInsets.only(left: 4, right: 4),
      child: Flexible(
        child: Container(
          alignment: Alignment.center,
          width: 100,
          height: 100,
          // color: Colors.black26,

          child: CachedNetworkImage(
            imageUrl:
                'https://tokoterserah.com/storage/produk/ulasan/' + url_img,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          // FadeInImage(
          //     placeholder: AssetImage('assets/fitness_app/logo.png'),
          //     image: NetworkImage(
          //         'https://tokoterserah.com/storage/produk/ulasan/' + url_img)),
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
