import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:best_flutter_ui_templates/fitness_app/fintness_app_theme.dart';

class ProductDetail extends StatefulWidget {
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0), child: HeaderPage()),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: BottomAppBar(
          child: new Row(
            children: <Widget>[
              Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ButtonTheme(
                  minWidth: 150,
                  height: 40,
                  child: RaisedButton(
                    child: Text(
                      'Masukkan Keranjang',
                      style: TextStyle(color: Colors.green),
                    ),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.green)),
                    onPressed: () {},
                  ),
                ),
              ),
              Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ButtonTheme(
                  minWidth: 150,
                  height: 40,
                  child: RaisedButton(
                    child: Text(
                      'Beli Sekarang',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                    onPressed: () {
                      // Navigate to the second screen using a named route.
                      Navigator.pushNamed(context, '/cart_list');
                    },
                  ),
                ),
              ),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[300],
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                //  HeaderPage(),
                CarouselImage(),
                JudulNHarga(),
                DetailProduk(),
                UlasanProduk(),
                PertanyaanProduk(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
// end stack end

class CarouselImage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselImage();
  }
}

class _CarouselImage extends State<CarouselImage> {
  int _current = 0;
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List<String> imgList = [
      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
    ];

    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(
                          item,
                          fit: BoxFit.cover,
                          width: 1000.0,
                          height: size.width - (size.width * 0.05),
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            // child: Text(
                            //   'No. ${imgList.indexOf(item)} image',
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 20.0,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    // return Container(
    //     height: size.width - (size.width * 0.05),
    //     color: Colors.white60,
    //     child: Center(child: Text('photo carousel')));
    return Container(
        child: new Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
              height: size.width - (size.width * 0.05),
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.map((url) {
            int index = imgList.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ],
    ));
  }
}

class JudulNHarga extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
        margin: EdgeInsets.only(bottom: 15),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            //harga
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      alignment: Alignment.topLeft,
                      width: size.width - 100,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Rp40.000,00',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Card(
                                  color: Colors.red[100],
                                  child: Container(
                                      margin: EdgeInsets.all(5),
                                      child: Text(
                                        '-10%',
                                        style: TextStyle(
                                          color: Colors.red[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      )),
                                ),
                                Text(
                                  'Rp50.000,00',
                                  style: TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.lineThrough),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ])),
                  Container(
                    width: 70,
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: null,
                      iconSize: 35,
                    ),
                  ),
                ],
              ),
            ),
            //judul
            Container(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Text(
                    'Lorem Epsum dolor siamet juang',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            //bintang
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 15),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    color: Colors.green[100],
                    child: Container(
                        margin: EdgeInsets.all(5),
                        child: Text(
                          'Grosir',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.green,
                    size: 25,
                  ),
                  Text(
                    ' 5.0 ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '  (11 ulasan)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            //stok, berat, minim
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 18),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Text("Stok : ", style: TextStyle(fontSize: 13)),
                            new Text("500 pcs ",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  new Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Text("Berat : ", style: TextStyle(fontSize: 13)),
                          new Text("0.12 kg ",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  new Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Text("Minim : ", style: TextStyle(fontSize: 13)),
                          new Text("50 pcs ",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class HeaderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double topBarOpacity = 0.0;
    TextEditingController editingController = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        color: FintnessAppTheme.white.withOpacity(topBarOpacity),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: FintnessAppTheme.grey.withOpacity(0.4 * topBarOpacity),
              offset: const Offset(1.1, 1.1),
              blurRadius: 10.0),
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16 - 8.0 * topBarOpacity,
                bottom: 12 - 8.0 * topBarOpacity),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40,
                  width: 270,
                  child: TextField(
                    onChanged: (value) {},
                    controller: editingController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Cari Produk",
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: "Cari Produk",
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.all(1.0),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0))),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 5.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                //),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 1,
                    right: 1,
                  ),
                  child: Row(
                    children: <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 3),
                      //   child: Icon(
                      //     Icons.notifications,
                      //     color: Colors.black,
                      //     size: 25,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: InkWell(
                          onTap: () {
                            // Navigate to the second screen using a named route.
                            Navigator.pushNamed(context, '/cart_list');
                          },
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: InkWell(
                          onTap: () {
                            // Navigate to the second screen using a named route.
                            Navigator.pushNamed(context, '/');
                          },
                          child: Icon(
                            Icons.home,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                      // Text(
                      //   '15 May',
                      //   textAlign: TextAlign.left,
                      //   style: TextStyle(
                      //     fontFamily: FintnessAppTheme.fontName,
                      //     fontWeight: FontWeight.normal,
                      //     fontSize: 18,
                      //     letterSpacing: -0.2,
                      //     color: FintnessAppTheme.darkerText,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 38,
                //   width: 38,
                //   child: InkWell(
                //     highlightColor: Colors.transparent,
                //     borderRadius: const BorderRadius.all(
                //         Radius.circular(32.0)),
                //     onTap: () {},
                //     child: Center(
                //       child: Icon(
                //         Icons.keyboard_arrow_right,
                //         color: FintnessAppTheme.grey,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DetailProduk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      width: size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
            child: Text('Detail Produk',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse tristique, erat sed mollis tincidunt, sapien leo lobortis quam, sed finibus tortor metus a dolor. Maecenas et ligula nibh. Suspendisse elit turpis, bibendum vitae consectetur condimentum, sollicitudin sed eros. Curabitur viverra bibendum massa, ac tincidunt arcu gravida ut. Nullam venenatis viverra vestibulum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam sapien, venenatis vitae porttitor vel, sollicitudin eu leo. Mauris arcu tellus, commodo vulputate ex sit amet, consequat tempor neque. Phasellus sodales ex sit amet sapien lobortis porta. Pellentesque maximus tortor lacus, in consequat quam varius ac. Donec et augue massa. Fusce ultricies pretium mauris ac mollis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse tristique, erat sed mollis tincidunt, sapien leo lobortis quam, sed finibus tortor metus a dolor. Maecenas et ligula nibh. Suspendisse elit turpis, bibendum vitae consectetur condimentum, sollicitudin sed eros. Curabitur viverra bibendum massa, ac tincidunt arcu gravida ut. Nullam venenatis viverra vestibulum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam sapien, venenatis vitae porttitor vel, sollicitudin eu leo. Mauris arcu tellus, commodo vulputate ex sit amet, consequat tempor neque. Phasellus sodales ex sit amet sapien lobortis porta. Pellentesque maximus tortor lacus, in consequat quam varius ac. Donec et augue massa. Fusce ultricies pretium mauris ac mollis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse tristique, erat sed mollis tincidunt, sapien leo lobortis quam, sed finibus tortor metus a dolor. Maecenas et ligula nibh. Suspendisse elit turpis, bibendum vitae consectetur condimentum, sollicitudin sed eros. Curabitur viverra bibendum massa, ac tincidunt arcu gravida ut. Nullam venenatis viverra vestibulum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam sapien, venenatis vitae porttitor vel, sollicitudin eu leo. Mauris arcu tellus, commodo vulputate ex sit amet, consequat tempor neque. Phasellus sodales ex sit amet sapien lobortis porta. Pellentesque maximus tortor lacus, in consequat quam varius ac. Donec et augue massa. Fusce ultricies pretium mauris ac mollis.',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.justify,
              maxLines: 7,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            decoration: borderTop(),
            child: Text(
              'Baca Selengkapnya',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class UlasanProduk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      width: size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //judul
          Container(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 8),
            child: Row(
              children: [
                Container(
                  width: size.width / 2 - 15,
                  alignment: Alignment.topLeft,
                  child: Text('Ulasan Produk',
                      style: TextStyle(
                        fontSize: 25,
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
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                )
              ],
            ),
          ),
          // bintang
          Container(
            width: size.width,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Row(
              children: <Widget>[
                Text('5.0',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                Text(' / 5.0 ',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                Icon(
                  Icons.star,
                  size: 25,
                  color: Colors.green,
                ),
                Text('  (11 Ulasan)',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    )),
              ],
            ),
          ),

          // gambar ulasan
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

          //ulasan top
          Container(
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
                    fontSize: 25,
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
          )
        ],
      ),
    );
  }
}

class PertanyaanProduk extends StatelessWidget {
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
          Container(
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
        ],
      ),
    );
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
            ),
          ),
        ),
      ));
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
