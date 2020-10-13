import 'package:flutter/material.dart';

import 'CustomShowDialog.dart';

class ProductDetail2 extends StatefulWidget {
  @override
  _ProductDetail2State createState() => _ProductDetail2State();
}

class HeaderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // double topBarOpacity = 0.0;
    TextEditingController editingController = TextEditingController();

    return AppBar(
      backgroundColor: Colors.grey[200],
      brightness: Brightness.light,
      leading: Transform.translate(
        offset: Offset(-5, 0),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      titleSpacing: -30,
      centerTitle: false,
      title: Container(
        padding: EdgeInsets.only(left: 20, right: 40),
        child: TextField(
          onChanged: (value) {},
          controller: editingController,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              // labelText: "Cari Produk",
              labelStyle: TextStyle(color: Colors.grey),
              hintText: "Cari Produk",
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.all(1.0),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 5.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)))),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: Stack(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Icon(
                    Icons.shopping_cart,
                    size: 24,
                    color: Colors.black54,
                  )),
              Container(
                margin: EdgeInsets.only(top: 8, left: 10),
                alignment: Alignment.center,
                height: 20,
                width: 20,
                child: Text(
                  '0',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w500),
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              )
            ],
          ),
        )
      ],
    );
  }
}


class _ProductDetail2State extends State<ProductDetail2> {
void showAddDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // CardCart(),
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 18,
                      padding: EdgeInsets.all(1.0),
                      child: Material(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Tambah Ke Keranjang',
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
    return Scaffold(
      appBar:  PreferredSize(
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
                    onPressed: () {
                      showAddDialog(context);
                    },
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
      
     body:Text('dasd')
    );
  }
}