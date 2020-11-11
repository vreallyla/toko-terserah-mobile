
import 'package:flutter/material.dart';


import 'package:intl/intl.dart';

class VoucherListScreen extends StatefulWidget {
  const VoucherListScreen({Key key, this.animationController})
      : super(key: key);

  final AnimationController animationController;
  @override
  _VoucherListScreenState createState() => _VoucherListScreenState();
}

class _VoucherListScreenState extends State<VoucherListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<dynamic> _listCart;

  List _selecteCarts = List();

  bool isLoading = true, isConnect = true, isCheckAll = false;

  int _total = 0;

  String _token;

  int jmlhCart = 0;

  // lock back when load data
  bool canBack = true;

  final formatter = new NumberFormat("#,###.00", 'id_ID');

  String userData;

  /**
   * Cutom Alert response
   * 
   */
  showSnackBar(String value, Color color, icons) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Row(
        children: <Widget>[
          icons,
          SizedBox(
            width: 20,
          ),
          Text(value)
        ],
      ),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;
    final bottom = MediaQuery.of(context).viewInsets.bottom;


    return WillPopScope(
      onWillPop: () {
        if (canBack) {
          Navigator.pop(context, jmlhCart);
        } else {
          showSnackBar(
              'Harap tunggu loading!', Colors.red, Icon(Icons.notifications));

          return;
        }
      },
      child: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
              child: new Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.grey[200],
            brightness: Brightness.light,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                if (canBack) {
                  Navigator.pop(context, jmlhCart);
                } else {
                  showSnackBar('Harap tunggu loading!', Colors.red,
                      Icon(Icons.notifications));

                  return;
                }
              },
            ),
            title: const Text(
              'Daftar Voucher',
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
          body: 
          // (_token == null
          //     ? noLogin()
          //     : (!isConnect
          //         ? noConnection()
          //         : (!isLoading ? mainContainter(context) : reqLoad()))),
                  mainContainter(context,bottom) 
        ),
      ),
    );
  }

  Widget noLogin() {
    return Container(
      alignment: Alignment.center,
      color: Color(0xfff0f4f7),
      padding: EdgeInsets.only(top: 120),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fitness_app/not_found.gif'),
                fit: BoxFit.fitHeight,
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
          ),
          Text(
            'Maaf Sob',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text('Silahkan login untuk menggunakan fitur ini',
              style: TextStyle(color: Colors.black54)),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              color: Colors.green,
              child: Text('Login', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Widget noConnection() {
    return Container(
      color: Color(0xfff0f4f7),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 120),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fitness_app/not_found.gif'),
                fit: BoxFit.fitHeight,
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
          ),
          Text(
            'Koneksi Terputus',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text('Periksa sambungan internet kamu',
              style: TextStyle(color: Colors.black54)),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  isConnect = true;
                });
              },
              color: Colors.green,
              child: Text('COBA LAGI', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Widget mainContainter(context,bottom) {
    final wh_ = MediaQuery.of(context).size;
    

    return Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: .5, color: Colors.grey[300]),
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right:10),
                    width: wh_.width - 51 - 70,
                    child: TextField(
                      style: TextStyle(height: .5,),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                          hintText: 'Masukkan Kode Voucher',
                          labelText: 'Kode Voucher'),
                    ),
                  ),
                  SizedBox(width: 60,child: RaisedButton(
                    color: Colors.green,
                    onPressed: (){},child: Text('Cari',style: TextStyle(color: Colors.white),),),)
                ],
              ),
            ),
            Container(height: wh_.height-190-bottom,
            margin: EdgeInsets.only(top:10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: .5, color: Colors.grey[300]),
              ),
            )
          ],
        ));
  }
}

  //  ListView.builder(
  //               physics: const BouncingScrollPhysics(),
  //               shrinkWrap: true,
  //               itemCount: _listCart.length == null ? 0 : _listCart.length,
  //               itemBuilder: (context, i) {
  //                 return Column(
  //                   children: [
  //                     Text(''),
  //                     SizedBox(
  //                       height: 20,
  //                     )
  //                   ],
  //                 );
  //               }),
         

// end stack end
