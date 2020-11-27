import 'package:tokoterserah/Constant/Constant.dart';
import 'package:tokoterserah/event/animation/spinner.dart';
import 'package:tokoterserah/fitness_app/models/meals_list_data.dart';
import 'package:tokoterserah/fitness_app/produk_detail/product_detail2.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:tokoterserah/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//import '../../main.dart';

class ItemSquareView extends StatefulWidget {
  const ItemSquareView(
      {Key key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.eventSetCart,
      this.dataCard})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;
  final List<dynamic> dataCard;
  final Function(int qty) eventSetCart;

  @override
  _ItemSquareViewState createState() => _ItemSquareViewState();
}

class _ItemSquareViewState extends State<ItemSquareView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<MealsListData> mealsListData = MealsListData.tabIconsList;

  Future<int> _toProductDetail(BuildContext context, String id) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductDetail2(
                  productId: id,
                )));

    return Future.value(result);
    // eventSetCart(result);
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
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
              height: sizeu.width / 3 + (sizeu.width / 3 / 3) + 150 - 75,
              width: double.infinity,
              child: ListView.builder(
                padding:
                    const EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
                itemCount: widget.dataCard.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      mealsListData.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  return MealsView(
                      eventSetCart: (int qty) async {
                        // int val=await qty;
                        // widget.eventSetCart( val);
                      },
                      linkIn: (int id) async {
                        // async {
                        final value =
                            await _toProductDetail(context, id.toString());
                        widget.eventSetCart( value);

                        // },
                      },
                      mealsListData: widget.dataCard[index],
                      animation: animation,
                      animationController: animationController,
                      countData:
                          widget.dataCard != null ? widget.dataCard.length : 0);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class MealsView extends StatelessWidget {
  const MealsView(
      {Key key,
      this.mealsListData,
      this.animationController,
      this.animation,
      this.linkIn,
      this.eventSetCart,
      this.countData})
      : super(key: key);

  final Map<String, dynamic> mealsListData;
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final int countData;
  final Function(int qty) eventSetCart;
  final Function(int qty) linkIn;

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

   
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
                        top: 0, left: 1, right: 5, bottom: 0),
                    child: InkWell(
                      onTap: ()
                          // async {
                          //   final value = await _toProductDetail(
                          //       context, mealsListData['id'].toString());
                          //   eventSetCart(value);
                          // },
                          {
                        linkIn(mealsListData['id']);
                      },
                      child: Column(
                        children: [
                          //rubah gambar
                          Container(
                            height: sizeu.width / 3,
                            width: double.infinity,
                            // width: sizeu.width / 3,

                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: .5,
                                  blurRadius: 1,
                                  offset: Offset(
                                      0, -.5), // changes position of shadow
                                ),
                              ],
                              color: Colors.grey,
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                            ),
                            child: (countData > 0
                                ? CachedNetworkImage(
                                    imageUrl: globalBaseUrl +
                                        locationProductImage +
                                        mealsListData['gambar'],
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fitHeight,
                                          // colorFilter: ColorFilter.mode(
                                          //     Colors.red, BlendMode.colorBurn)
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Spinner(
                                        icon: Icons.refresh,
                                        color: Colors.black54),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                : Spinner(
                                    icon: Icons.refresh,
                                    color: Colors.black54)),
                          ),

                          //konten
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                            height: 115,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: .4,
                                  blurRadius: .5,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                                bottomRight: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    mealsListData['nama'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    NumberFormat.currency(
                                            locale: "id_ID", symbol: "Rp")
                                        .format(int.parse(mealsListData[
                                                    'harga_grosir'] !=
                                                null
                                            ? (mealsListData['diskonGrosir'] !=
                                                    null
                                                ? mealsListData[
                                                    'harga_diskon_grosir']
                                                : mealsListData['harga_grosir'])
                                            : (mealsListData['diskon'] != null
                                                ? mealsListData['harga_diskon']
                                                : mealsListData['harga']))),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Card(
                                      color: Colors.red[100],
                                      child: Container(
                                          padding: EdgeInsets.all(
                                              mealsListData['diskon'] != null ||
                                                      mealsListData[
                                                              'diskonGrosir'] !=
                                                          null
                                                  ? 2
                                                  : 0),
                                          child: Text(
                                            '-' +
                                                (mealsListData['diskon'] != null
                                                    ? mealsListData['diskon']
                                                    : (mealsListData[
                                                                'diskonGrosir'] !=
                                                            null
                                                        ? mealsListData[
                                                            'diskonGrosir']
                                                        : '0')) +
                                                '%',
                                            style: TextStyle(
                                              color: Colors.red[800],
                                              fontWeight: FontWeight.bold,
                                              fontSize: mealsListData[
                                                              'diskon'] !=
                                                          null ||
                                                      mealsListData[
                                                              'diskonGrosir'] !=
                                                          null
                                                  ? 8
                                                  : 0,
                                            ),
                                          )),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                              locale: "id_ID", symbol: "Rp")
                                          .format(int.parse(
                                              (mealsListData['harga'] != null
                                                  ? mealsListData['harga']
                                                  : (mealsListData[
                                                              'harga_grosir'] !=
                                                          null
                                                      ? mealsListData[
                                                          'harga_grosir']
                                                      : '0')))),
                                      style: TextStyle(
                                          fontSize:
                                              mealsListData['diskon'] != null ||
                                                      mealsListData[
                                                              'diskonGrosir'] !=
                                                          null
                                                  ? 11
                                                  : 0,
                                          decoration:
                                              TextDecoration.lineThrough),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                starJadi(
                                    double.parse(
                                        mealsListData['avg_ulasan'].toString()),
                                    NumberFormat("#,###", "id_ID")
                                        .format(mealsListData['count_ulasan'])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 5, left: 5, right: 5, bottom: 0),
                    alignment: Alignment.topLeft,
                    child: Card(
                      color: Colors.green[100],
                      child: Container(
                          margin: EdgeInsets.all(3),
                          child: Text(
                            'Grosir',
                            style: TextStyle(
                              color: Colors.green[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          )),
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
      size: 12,
    );
  }

  Icon iconStarSetengah() {
    return Icon(
      Icons.star_half,
      color: Colors.green,
      size: 12,
    );
  }

  Icon iconStarKosong() {
    return Icon(
      Icons.star_border,
      color: Colors.lightGreen,
      size: 12,
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
}
