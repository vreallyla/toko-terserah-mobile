import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:best_flutter_ui_templates/fitness_app/models/meals_list_data.dart';
import 'package:best_flutter_ui_templates/model/wishlist_model.dart';
//import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

//import '../../main.dart';

class ItemWishlistView extends StatefulWidget {
  const ItemWishlistView(
      {Key key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.countWishlist,
      this.dataWishlist})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;
  final int countWishlist;
  final List dataWishlist;

  @override
  _ItemWishlistViewState createState() => _ItemWishlistViewState();
}

class _ItemWishlistViewState extends State<ItemWishlistView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<dynamic> loadWishlist = [];
  bool isLoading = false;

  _deleteWish(int iDB) async {
    await WishlistModel.deleteWish(iDB.toString()).then((value) {
      isLoading = false;
      setState(() {
        // print(loadWishlist[0]);
      });
      print(value);
    });
  }

  void removeWishlishCard(int iCard, int iDB) {
    isLoading = true;
    print(iDB);

    setState(() {
      // print(loadWishlist[0]);
    });

    _deleteWish(iDB);

    // print(index);
    loadWishlist.removeAt(iCard);
    // isLoading=false;
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    // loadWishlist = List.generate(
    //     5, (index) => MealsView(removeWishlishCard, index: index));
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loadWishlist = widget.dataWishlist;

    // print(widget.dataWishlist[0]['nama']);
    final sizeu = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 20 * (1.0 - widget.mainScreenAnimation.value), 0.0),
              child: Container(
                height: sizeu.height - 270,
                width: double.infinity,
                child: (isLoading
                    ? reqLoad()
                    : (loadWishlist.length == 0
                        ? dataKosong()
                        : ListView.builder(
                            padding: const EdgeInsets.only(
                                top: 0, bottom: 0, right: 0, left: 0),
                            itemCount: loadWishlist.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              final int count = loadWishlist.length > 10
                                  ? 10
                                  : loadWishlist.length;
                              final Animation<double> animation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                      CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn)));
                              animationController.forward();

                              return MealsView(removeWishlishCard,
                                  loadWishlist: loadWishlist[index],
                                  animation: animation,
                                  animationController: animationController,
                                  index: index
                                  // removeWishlishCards:removeWishlishCard,
                                  );
                            },
                          ))),
              )),
        );
      },
    );
  }
}

class MealsView extends StatelessWidget {
  const MealsView(this.removeWishlishCard,
      {Key key,
      this.loadWishlist,
      this.animationController,
      this.animation,
      this.index})
      : super(key: key);

  final loadWishlist;
  final int index;
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final Function(int iCard, int iDB) removeWishlishCard;
  // print(this

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    var product = loadWishlist['get_produk'];

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0 * (1.0 - animation.value), 0.0, 0.0),
            child: SizedBox(
              width: sizeu.width / 3,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, left: 10, right: 10, bottom: 15),
                    child: InkWell(
                      onTap: () {
                        // Navigate to the second screen using a named route.
                        Navigator.pushNamed(context, '/produk');
                      },
                      child:
                          //rubah gambar
                          Container(
                        height: sizeu.width / 2 -
                            sizeu.width / 15 +
                            sizeu.width / 3 / 3 -
                            20,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: sizeu.width / 4,
                                    width: sizeu.width / 4,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: (product['gambar'] != null
                                            ? NetworkImage(globalBaseUrl +
                                                locationProductImage +
                                                product['gambar'])
                                            : AssetImage(
                                                'assets/fitness_app/bg_users.jpg')),
                                        fit: BoxFit.cover,
                                      ),
                                      color: Colors.black26,
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: sizeu.width / 4 +
                                        sizeu.width / 3 / 3 -
                                        20,
                                    padding: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.topLeft,
                                          width: sizeu.width -
                                              50 -
                                              sizeu.width / 4 -
                                              10,
                                          child: Text(
                                            product['nama'].toString(),
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Card(
                                              color: Colors.green[100],
                                              child: Container(
                                                  margin: EdgeInsets.all(2),
                                                  child: Text(
                                                    (product['isGrosir'] == 1
                                                        ? 'Grosir'
                                                        : 'Retail'),
                                                    style: TextStyle(
                                                      color: Colors.green[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  )),
                                            ),
                                            Card(
                                              color: Colors.blue[100],
                                              child: Container(
                                                  margin: EdgeInsets.all(2),
                                                  child: Text(
                                                    (product['stock'] + ' pcs'),
                                                    style: TextStyle(
                                                      color: Colors.blue[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          width: sizeu.width -
                                              50 -
                                              sizeu.width / 4 -
                                              10,
                                          child: Text(
                                            NumberFormat.currency(
                                                    locale: "id_ID",
                                                    symbol: "Rp")
                                                .format(int.parse(product[
                                                            'isGrosir'] !=
                                                        0
                                                    ? (product['isDiskonGrosir'] !=
                                                            0
                                                        ? product[
                                                            'harga_diskon_grosir']
                                                        : product[
                                                            'harga_grosir'])
                                                    : (product['is_diskon'] != 0
                                                        ? product[
                                                            'harga_diskon']
                                                        : product['harga']))),
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Card(
                                              color: Colors.red[100],
                                              child: Container(
                                                  margin: EdgeInsets.all(
                                                      product['is_diskon'] !=
                                                                  0 ||
                                                              product['isDiskonGrosir'] !=
                                                                  0
                                                          ? 2
                                                          : 0
                                                      // 2
                                                      ),
                                                  child: Text(
                                                    '-' +
                                                        (product['isGrosir'] !=
                                                                0
                                                            ? (product[
                                                                    'diskonGrosir'] ??
                                                                '0')
                                                            : (product[
                                                                    'diskon'] ??
                                                                '0')) +
                                                        '%',
                                                    style: TextStyle(
                                                      color: Colors.red[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          product['is_diskon'] !=
                                                                      0 ||
                                                                  product['isDiskonGrosir'] !=
                                                                      0
                                                              ? 12
                                                              : 0,
                                                    ),
                                                  )),
                                            ),
                                            Text(
                                              NumberFormat.currency(
                                                      locale: "id_ID",
                                                      symbol: "Rp")
                                                  .format(int.parse(
                                                      (product['isGrosir'] != 0
                                                          ? product[
                                                              'harga_grosir']
                                                          : product['harga']))),
                                              style: TextStyle(
                                                  fontSize: product[
                                                                  'is_diskon'] !=
                                                              0 
                                                              ||
                                                          product['isDiskonGrosir'] !=
                                                              0
                                                      ? 15
                                                      : 0,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        starJadi(
                                            double.parse(
                                                loadWishlist['avg_ulasan']
                                                    .toString()),
                                            NumberFormat("#,###", "id_ID")
                                                .format(loadWishlist[
                                                    'count_ulasan']),
                                            sizeu.width -
                                                50 -
                                                sizeu.width / 4 -
                                                10),
                                      ],
                                    ),
                                  ),
                                ]),
                            Container(
                              height: sizeu.width / 2 -
                                  sizeu.width / 15 -
                                  30 -
                                  sizeu.width / 4,
                              // color: Colors.red,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      color: Colors.white,
                                      width: sizeu.width - 50 - 80,
                                      child: RaisedButton(
                                        onPressed: () {},
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Text(
                                          'MASUKKAN KERANJANG',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: (product['isGrosir'] == 1
                                                ? int.parse(
                                                        product['min_qty']) <=
                                                    int.parse(product['stock'])
                                                : int.parse(product['stock']) !=
                                                    0)
                                            ? Colors.green
                                            : Colors.black12,
                                      )),
                                  Container(
                                      width: 80,
                                      padding: EdgeInsets.only(left: 5),
                                      color: Colors.white,
                                      child: RaisedButton(
                                        onPressed: () {
                                          // removeWishlishCard(this);

                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0)), //this right here
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 180,
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 8,
                                                                      bottom:
                                                                          15),
                                                              child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .times,
                                                                color: Colors
                                                                    .black54,
                                                                size: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    right: 10),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                                'Apakah Anda yakin? Data akan hilang',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        18)),
                                                          ),
                                                          Container(
                                                              color:
                                                                  Colors.white,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              height: 100,
                                                              child: Row(
                                                                children: [
                                                                  Spacer(
                                                                    flex: 1,
                                                                  ),
                                                                  RaisedButton(
                                                                    child: Text(
                                                                      'Ya',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    color: Colors
                                                                        .green,
                                                                    onPressed:
                                                                        () {
                                                                      // removeWishlishCard(
                                                                      //     index, loadWishlist['id']);
                                                                      // print('hapus wishlist '+ loadWishlist['id'].toString());
                                                                    },
                                                                  ),
                                                                  Spacer(
                                                                    flex: 1,
                                                                  ),
                                                                  RaisedButton(
                                                                    child: Text(
                                                                      'Tidak',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    color: Colors
                                                                            .red[
                                                                        500],
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
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
                                                );
                                              });
                                        },
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.black12),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        color: Colors.red[400],
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Icon iconStar() {
    return Icon(
      Icons.star,
      color: Colors.green,
      size: 13,
    );
  }

  Icon iconStarSetengah() {
    return Icon(
      Icons.star_half,
      color: Colors.green,
      size: 13,
    );
  }

  Icon iconStarKosong() {
    return Icon(
      Icons.star_border,
      color: Colors.lightGreen,
      size: 13,
    );
  }

  Container starJadi(double jmlStar, String jlmVote, double wit) {
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
        style: TextStyle(fontSize: 13, color: Colors.grey)));

    return Container(width: wit, child: Row(children: dataRown));
  }
}
