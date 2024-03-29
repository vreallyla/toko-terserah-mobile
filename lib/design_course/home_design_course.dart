import 'dart:convert';
import 'package:tokoterserah/Controllers/harga_controller.dart';
import 'package:tokoterserah/design_course/course_info_screen.dart';
import 'package:tokoterserah/fitness_app/produk_detail/product_detail2.dart';
import 'package:tokoterserah/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'design_course_app_theme.dart';
import 'package:tokoterserah/fitness_app/fintness_app_theme.dart';
import 'package:tokoterserah/hotel_booking/range_slider_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:tokoterserah/Constant/Constant.dart';
import 'dart:async';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:searchable_dropdown/searchable_dropdown.dart';

class HomeDesignCourse extends StatefulWidget {
  final String jenis;
  final String search;
  final Function(int qty) funcChangeCartQty;
  const HomeDesignCourse({
    Key key,
    this.jenis = 'semua',
    this.search = '',
    this.funcChangeCartQty,
  }) : super(key: key);

  @override
  _HomeDesignCourseState createState() => _HomeDesignCourseState();
}

class NewItem {
  bool isExpanded;
  String header;
  Widget body;
  Icon iconpic;
  NewItem(this.isExpanded, this.header, this.body, this.iconpic);
}

class _HomeDesignCourseState extends State<HomeDesignCourse> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CategoryType categoryType = CategoryType.ui;
  String dropdownValue;
  String subdropdownValue;
  TextEditingController editingController = TextEditingController();
  RangeValues _values = const RangeValues(100, 600);
  double distValue = 50.0;
  AnimationController animationController;
  Animation<dynamic> animation;
  List dataJson, dataSubKategori;
  bool isLoading = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _limit = 10;
  List _selecteCategorys = List();
  List _selectKategoriDetail = List();
  final formatter = new NumberFormat("#,###");

  List<NewItem> items = <NewItem>[
    new NewItem(
        false, 'Filter dan Kategori', SizedBox(), new Icon(Icons.expand_more)),
    //give all your items here
  ];

  Future getData() async {
    try {
      // print(_selecteCategorys.join(','));
      var param = jsonEncode({
        "limit": _limit.toString(),
        "name": editingController.text,
        "awal": _currentRangeValues.start.toString(),
        "akhir": _currentRangeValues.end.toString(),
        "jenis": _jenisProdukRadioButton,
        "kategori":
            _selecteCategorys.length > 0 ? _selecteCategorys.join(',') : null
      });

      // print(param);
      http.Response item = await http.post(globalBaseUrl + 'api/search',
          body: param,
          headers: {
            "Accept": "application/json",
            'Content-type': 'application/json'
          });

      if (item.statusCode == 200) {
        Map<String, dynamic> products = jsonDecode(item.body);
        // print(products['data']['produk']);

        setState(() {
          dataJson = products['data']['produk'];
          // print(dataJson);
          isLoading = false;
        });
      }
    } catch (e) {
      log("error getData : $e");
    }
  }

  Future getSubKategori() async {
    setState(() {
      isLoadingSub = true;
    });
    try {
      http.Response item = await http
          .get(globalBaseUrl + 'api/master/sub?nama=' + cariKatagoriInput.text);

      if (item.statusCode == 200) {
        Map<String, dynamic> products = jsonDecode(item.body);
        // print(products['data']);

        setState(() {
          dataSubKategori = products['data'];
        });
      }
      setState(() {
        isLoadingSub = false;
      });
    } catch (e) {
      setState(() {
        isLoadingSub = false;
      });
      log("error getSub : $e");
    }
  }

  // Fetching data from API to Model Products

  // /**
  //  * Parsing value from API to model Products
  //  *
  //  */
  // Products _fromJson(Map<String, dynamic> item) {
  //   log('id ke-${item['id']}');
  //   return new Products(
  //     id: item['id'],
  //     name: item['nama'],
  //     price: item['harga'],
  //   );
  // }

  ListView listcriteria;

  //cari kategori produk
  TextEditingController cariKatagoriInput = new TextEditingController();
  var focusCariKategori = new FocusNode();
  //checkbox components
  bool checkBoxValue = false;

  //jenis produk
  String _jenisProdukRadioButton =
      "semua"; //Initial definition of radio button value

  //variable kategori
  List dataKategori = [];
  List widgetContainerKategori = <Widget>[];
  List collectKategori = [];
  Map<int, bool> valueKategori = {};
  bool isKategori = false;

  //variable range harga
  TextEditingController minHargaInput = new TextEditingController();
  TextEditingController maxHargaInput = new TextEditingController();
  RangeValues _currentRangeValues = RangeValues(0, 30000000);

  void setKatagoriListAll(context) {
    // collectKategori = [];
    // widgetContainerKategori = <Widget>[];
    // dataKategori.asMap().forEach((iKategori, value) {
    //   // widgetContainerKategori=[];
    //   collectKategori.add(<Widget>[]);
    //   collectKategori[iKategori]
    //       .add(textKategoriProduk(value['nama_kategori']));

    //   value['data'].asMap().forEach((iData, value2) {
    //     valueKategori[value2['id']] = false;
    //     print(value2['id']);
    //     collectKategori[iKategori].add(kategoriProdukCheckBox(
    //         value2['nama'], context.size, iKategori, iData, value2['id']));
    //   });
    //   print(collectKategori);

    //   widgetContainerKategori.add(
    //     Container(
    //       padding: EdgeInsets.only(bottom: 20),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: collectKategori[iKategori],
    //       ),
    //     ),
    //   );
    // });
  }

  checkBorderChanges(value) {
    return _jenisProdukRadioButton == value ? Colors.green : Colors.black26;
  }

  void radioButtonChanges(String value) {
    setState(() {
      setState(() {
        _jenisProdukRadioButton = value;
      });
      debugPrint(_jenisProdukRadioButton); //Debug the choice in console
    });
  }

  bool isLoadingSub = false;

  @override
  void initState() {
    editingController.text = widget.search;
    _jenisProdukRadioButton = widget.jenis;

    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      //set kategori on widget
      setKatagoriListAll(context);
    });

    // print(dataKategori[0]['data'][0]);
    getSubKategori();
    getData();
  }

  Text textKategoriProduk(value) {
    return Text(value,
        style: TextStyle(
            color: Colors.green, fontSize: 12, fontWeight: FontWeight.w100));
  }

  Container kategoriProdukCheckBox(nama, sizeu, iKategori, iData, id) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.blueGrey.withOpacity(.2)),
        ),
      ),
      padding: EdgeInsets.only(right: 10, bottom: 10, top: 20),
      child: Row(
        children: [
          SizedBox(
              height: 20,
              width: 20,
              child: Checkbox(
                activeColor: Colors.green,
                value: valueKategori[id],
                onChanged: (bool newValue) {
                  // print("object");
                  // print(newValue);
                  // print(valueKategori[id]);
                  // print(id);
                  setState(() {
                    valueKategori[id] = newValue;
                  });
                },
              )),
          InkWell(
            onTap: () {
              valueKategori[id] = !valueKategori[id];
              setState(() {});
            },
            child: Container(
              width: sizeu.width - sizeu.width / 5 - 20 - 20,
              padding: EdgeInsets.only(left: 10),
              child: Text(
                nama,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(.7),
                    fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

//Render Data Kategori dari API dan ditampilkan pada widget
  Widget listKategoriCheckBox(context) {
    return ListView.builder(
        itemCount: dataSubKategori == null ? 0 : dataSubKategori.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          if (dataSubKategori[i]['nama']
                  .toLowerCase()
                  .indexOf(cariKatagoriInput.text.toLowerCase()) >=
              0) {
            return CheckboxListTile(
              value: _selecteCategorys.contains(dataSubKategori[i]['id']),
              onChanged: (bool selected) {
                _onCategorySelected(selected, dataSubKategori[i]['id'],
                    dataSubKategori[i]['nama']);
              },
              title: Text(dataSubKategori[i]['nama']),
            );
          }
        });
  }

  List pickKategoriSearch(int i) {
    int indexx = i * 2;

    int unIndex = indexx + (_selecteCategorys.length < indexx + 2 ? 1 : 2);

    List<Widget> pickKategori = <Widget>[];

    for (int ina = indexx; ina < unIndex; ina++) {
      pickKategori.add(Expanded(
          flex: 1,
          child: Container(
            height: 30,
            margin: EdgeInsets.only(left: 2, right: 2),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.green,
                ),
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    // width: 30,
                    padding: EdgeInsets.only(right: 5, left: 5),
                    child: Text(
                      _selectKategoriDetail[ina]['nama'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                Container(
                  child: SizedBox(
                    width: 20,
                    child: InkWell(
                      onTap: () {
                        print(_selectKategoriDetail[ina]['id']);
                        _onCategorySelected(
                            false,
                            _selectKategoriDetail[ina]['id'],
                            _selectKategoriDetail[ina]['nama']);
                      },
                      child: FaIcon(
                        FontAwesomeIcons.timesCircle,
                        size: 14,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )));
    }

    if (_selecteCategorys.length < indexx + 2 ? true : false) {
      pickKategori.add(Expanded(
        flex: 1,
        child: Container(),
      ));
    }
    return pickKategori;
  }

  //desain kategori produk
  Widget kategoriDetail(sizeu) {
    return Stack(
      children: <Widget>[
        //body
        Container(
          margin: EdgeInsets.only(
              top: _selecteCategorys.length > 0
                  ? ((_selecteCategorys.length / 2).ceil() > 1 ? 140 : 100)
                  : 60,
              bottom: 150),
          padding: EdgeInsets.only(left: 10, top: 5),
          color: Colors.white,
          // child: ListView(
          //   // daftar kategori
          //   children: widgetContainerKategori,
          // ),
          child: isLoadingSub
              ? Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text('Loading...'),
                )
              : listKategoriCheckBox(context),
        ),
        //header
        Container(
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.only(left: 10, bottom: 10),
          height: _selecteCategorys.length > 0
              ? ((_selecteCategorys.length / 2).ceil() > 1 ? 210 : 170)
              : 128,
          decoration: BoxDecoration(
            // border: Border(
            //   bottom: BorderSide(
            //       width: .4, color: Colors.blueGrey.withOpacity(.2)),
            // ),
            color: Colors.white,
          ),
          width: sizeu.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ListView.builder(
                  // physics: const BouncingScrollPhysics(),

                  shrinkWrap: true,
                  itemCount: _selecteCategorys.length > 0
                      ? (_selecteCategorys.length / 2).ceil()
                      : 0,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, i) {
                    return Container(
                      padding: EdgeInsets.only(left: 0, right: 7, top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: pickKategoriSearch(i),
                      ),
                    );
                  }),
              Container(
                width: sizeu.width - sizeu.width / 5 - 20,
                padding: EdgeInsets.only(left: 5, right: 5),
                margin: EdgeInsets.only(right: 7, top: 10),
                height: 30,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                  color: Colors.blueGrey.withOpacity(.2),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 30,
                      width: 20,
                      child: Icon(
                        Icons.search,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Container(
                      width: sizeu.width - sizeu.width / 5 - 20 - 50,
                      padding: EdgeInsets.only(left: 7, top: 15),
                      child: TextField(
                        focusNode: focusCariKategori,
                        maxLength: 27,
                        controller: cariKatagoriInput,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: "Cari Kategori...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.black45),
                        ),
                        style:
                            TextStyle(color: Colors.blueGrey, fontSize: 13.0),
                        onSubmitted: (val) {
                          getSubKategori();
                          setState(() {});
                        },
                        // onChanged: (query) {
                        //   print(query);
                        //   // cariKatagoriInput.text = query;

                        //   setState(() {});
                        // },
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        cariKatagoriInput.text = '';
                        getSubKategori();

                        setState(() {
                          focusCariKategori.requestFocus();
                        });
                      },
                      child: SizedBox(
                        height: 15,
                        width: 20,
                        child: FaIcon(FontAwesomeIcons.timesCircle,
                            color: Colors.blueGrey, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        //footer
        Container(
          margin: EdgeInsets.only(top: sizeu.height - 150),
          padding: EdgeInsets.only(top: 15, right: 20),
          // alignment: Alignment.topRight,
          height: 140,
          width: sizeu.width,
          decoration: BoxDecoration(
            border: Border(
              top:
                  BorderSide(width: .4, color: Colors.blueGrey.withOpacity(.2)),
            ),
            color: Colors.blueGrey.withOpacity(.2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                  height: 30,
                  child: RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: Colors.green)),
                    child: Text(
                      'RESET',
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                    onPressed: () {
                      // isKategori = false;
                      _selectKategoriDetail = [];
                      _selecteCategorys = [];

                      setState(() {});
                    },
                  )),
              Container(
                  margin: EdgeInsets.only(left: 10),
                  height: 30,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      // side: BorderSide(color: Colors.green)
                    ),
                    color: Colors.green,
                    child: Text(
                      'SET',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    onPressed: () {
                      isKategori = false;
                      setState(() {});
                    },
                  ))
            ],
          ),
        ),
      ],
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    getData();
    log("message : data Successfuly Refreshed");
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    setState(() {
      _limit = _limit + 10;
    });

    getData();
    log("message : data Successfuly Loaded");

    _refreshController.loadComplete();
  }

  void _openEndDrawer() {
    cariKatagoriInput.text = '';
    setState(() {});
    _scaffoldKey.currentState.openEndDrawer();
  }

  void _closeEndDrawer() {
    isKategori = false;
    setState(() {});
    Navigator.of(context).pop();
  }

  _toProductDetail(BuildContext context, String id) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final resultDetail = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetail2(
            productId: id,
          ),
        ));

    setState(() {
      widget.funcChangeCartQty(resultDetail);
    });
  }

  _inputToSlider(String awal, String akhir) {
    try {
      log("Awal : " + awal + " Akhir : " + akhir);
      double _valueAwal = double.parse(awal);
      double _valueAkhir = double.parse(akhir);
      if (_valueAwal >= _valueAkhir) {
        minHargaInput.text = akhir;
      }
      if (_valueAkhir <= _valueAwal) {
        maxHargaInput.text = awal;
      }
      _currentRangeValues = RangeValues(_valueAwal, 30000000);
    } catch (e) {
      log("eror : " + e.toString());
    }
  }

  //Set value from check box
  void _onCategorySelected(bool selected, int categoryId, String categoryNama) {
    if (selected == true) {
      if (_selecteCategorys.length < 4) {
        setState(() {
          _selecteCategorys.add(categoryId);
          _selectKategoriDetail.add({"id": categoryId, "nama": categoryNama});
        });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0)), //this right here
                child: Container(
                  height: 160,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.bottomRight,
                            padding: EdgeInsets.only(right: 8, bottom: 15),
                            child: FaIcon(
                              FontAwesomeIcons.times,
                              color: Colors.black54,
                              size: 16,
                            ),
                          ),
                        ),
                        Container(
                          child: Text('Maksimal cek 4 kategori',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18)),
                        ),
                        Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(5),
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton(
                                  child: Text(
                                    'OK',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.green,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              );
            });
      }
    } else {
      setState(() {
        print(categoryNama);

        _selecteCategorys.remove(categoryId);

        _selectKategoriDetail.removeWhere((item) => item['id'] == categoryId);
        // _selectKategoriDetail.removeAt(0);

        // Stream.fromIterable(_selectKategoriDetail).asyncMap((item) async => {"id": categoryId, "nama": await categoryNama }).where((m) => m['id'] != categoryId).toList();
        // Stream.fromIterable(replytile).asyncMap((item) async => {"item": item, "id": await item.id }).where((m) => m.id != '001').map((m) => m.item)).toList()
        // _listofTaskUI.removeAt(_quantity);
      });
    }

    print(_selectKategoriDetail);
  }

  @override
  Widget build(BuildContext context) {
    var sizeu = MediaQuery.of(context).size;

//    const test = 'a';
    items = <NewItem>[
      new NewItem(
          items[0].isExpanded,
          'Filter dan Kategori',
          Column(
            children: <Widget>[
              kategorifilter(),
              priceBarFilter(),
            ],
          ),
          new Icon(Icons.expand_more)),
      //give all your items here
    ];
    listcriteria = ListView(
      shrinkWrap: true,
      children: [
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              items[0].isExpanded = !isExpanded;
              print(items[0].isExpanded);
            });
          },
          children: items.map((NewItem item) {
            return new ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                print(item.isExpanded);
                return new ListTile(
                    title: new Text(
                  item.header,
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                    fontSize: 18.0,
                    color: Colors.green,
                    fontWeight: FontWeight.w200,
                  ),
                ));
              },
              isExpanded: item.isExpanded,
              body: item.body,
            );
          }).toList(),
        ),
      ],
    );

    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SafeArea(
       
        child: Container(
          color: DesignCourseAppTheme.nearlyWhite,
          child: Scaffold(
            key: _scaffoldKey,
            endDrawer: Container(
              width: sizeu.width - sizeu.width / 5,
              child: Drawer(
                  child: (isKategori
                      ? kategoriDetail(sizeu)
                      : Stack(
                          children: <Widget>[
                            //header
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.only(left: 10, bottom: 10),
                              height: 70,
                              color: Colors.blueGrey.withOpacity(.2),
                              width: sizeu.width,
                              child: Text(
                                'Filter',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ),
                            //body
                            Container(
                              margin: EdgeInsets.only(top: 70, bottom: 130),
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              color: Colors.white,
                              child: ListView(children: <Widget>[
                                // kategori produk
                                Container(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          'Kategori Produk',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.withOpacity(0.2),
                                          border: Border(
                                            top: BorderSide(
                                                width: 2, color: Colors.green),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(top: 0),
                                          // height: 40,
                                          decoration: BoxDecoration(
                                              // border: Border.all(
                                              //   color: Colors.black26,
                                              // ),
                                              // borderRadius: BorderRadius.circular(4),
                                              color: Colors.blueGrey
                                                  .withOpacity(.2)),
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    isKategori = true;
                                                    setKatagoriListAll(context);
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                        minHeight: 40,
                                                        maxHeight: 100),
                                                    width: sizeu.width -
                                                        sizeu.width / 5 -
                                                        20 -
                                                        30,
                                                    // color: Colors.black,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 12, 0, 12),
                                                      child: _selecteCategorys
                                                                  .length ==
                                                              0
                                                          ? Text(
                                                              'Pilih Kategori',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .blueGrey,
                                                              ),
                                                            )
                                                          : ListView.builder(
                                                              // physics: const BouncingScrollPhysics(),

                                                              shrinkWrap: true,
                                                              itemCount: _selecteCategorys
                                                                          .length >
                                                                      0
                                                                  ? (_selecteCategorys
                                                                              .length /
                                                                          2)
                                                                      .ceil()
                                                                  : 0,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemBuilder:
                                                                  (context, i) {
                                                                return Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left: 0,
                                                                          right:
                                                                              7,
                                                                          top: i >
                                                                                  0
                                                                              ? 10
                                                                              : 0),
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children:
                                                                        pickKategoriSearch(
                                                                            i),
                                                                  ),
                                                                );
                                                              }),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.topCenter,
                                                  width: 30,
                                                  // color: Colors.black,
                                                  child: SizedBox(
                                                    height: 40,
                                                    width: 30,
                                                    child: IconButton(
                                                      color: Colors.blueGrey,
                                                      icon: FaIcon(
                                                          FontAwesomeIcons.times),
                                                      iconSize: 13,
                                                      tooltip: 'Close',
                                                      onPressed: () {
                                                        //event hapus data multiple kategori produk
                                                        _selectKategoriDetail =
                                                            [];
                                                        _selecteCategorys = [];

                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ]))
                                    ],
                                  ),
                                ),

                                //jenis produk
                                Container(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          'Jenis Produk',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.withOpacity(0.2),
                                          border: Border(
                                            top: BorderSide(
                                                width: 2, color: Colors.green),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _jenisProdukRadioButton =
                                                        'semua';
                                                  });
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.all(8),
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  // width: sizeu.width-(sizeu.width/5)-21,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: checkBorderChanges(
                                                          'semua'),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 18,
                                                        height: 18,
                                                        child: Radio(
                                                          activeColor:
                                                              Colors.green,
                                                          value: 'semua',
                                                          groupValue:
                                                              _jenisProdukRadioButton,
                                                          onChanged:
                                                              radioButtonChanges,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                            left: 6),
                                                        child: Text(
                                                          "Semua",
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _jenisProdukRadioButton =
                                                        'grosir';
                                                  });
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.all(8),
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  // width: sizeu.width-(sizeu.width/5)-21,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: checkBorderChanges(
                                                          'grosir'),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 18,
                                                        height: 18,
                                                        child: Radio(
                                                          activeColor:
                                                              Colors.green,
                                                          value: 'grosir',
                                                          groupValue:
                                                              _jenisProdukRadioButton,
                                                          onChanged:
                                                              radioButtonChanges,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                            left: 6),
                                                        child: Text(
                                                          "Grosir",
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _jenisProdukRadioButton =
                                                        'retail';
                                                  });
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.all(8),
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  // width: sizeu.width-(sizeu.width/5)-21,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: checkBorderChanges(
                                                          'retail'),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 18,
                                                        height: 18,
                                                        child: Radio(
                                                          activeColor:
                                                              Colors.green,
                                                          value: 'retail',
                                                          groupValue:
                                                              _jenisProdukRadioButton,
                                                          onChanged:
                                                              radioButtonChanges,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                            left: 6),
                                                        child: Text(
                                                          "Retail",
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                //harga produk
                                Container(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          'Harga Produk',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.withOpacity(0.2),
                                          border: Border(
                                            top: BorderSide(
                                                width: 2, color: Colors.green),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(top: 3),
                                          padding: EdgeInsets.only(top: 5),
                                          height: 90,
                                          width:
                                              sizeu.width - sizeu.width / 5 - 10,
                                          color: Colors.blueGrey.withOpacity(.2),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 35,
                                                      width: 110,
                                                      child: TextField(
                                                          // enabled: false,
                                                          readOnly: true,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blueGrey,
                                                              fontSize: 13.0),
                                                          controller:
                                                              minHargaInput,
                                                          onChanged: (text) {
                                                            //Set value to slider
                                                            print(text);
                                                          },
                                                          onSubmitted: (text) {
                                                            setState(() {
                                                              _inputToSlider(
                                                                  text,
                                                                  maxHargaInput
                                                                      .text);
                                                            });
                                                          },
                                                          // onSubmitted: (_) =>
                                                          //     FocusScope.of(
                                                          //             context)
                                                          //         .nextFocus(),
                                                          decoration:
                                                              defaultInput(
                                                                  'Terendah',
                                                                  false)),
                                                    ),
                                                    Container(
                                                      width: sizeu.width -
                                                          sizeu.width / 5 -
                                                          230 -
                                                          30,
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        '-',
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color:
                                                                Colors.blueGrey),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 35,
                                                      width: 120,
                                                      child: TextField(
                                                          // enabled: false,
                                                          readOnly: true,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blueGrey,
                                                              fontSize: 13.0),
                                                          controller:
                                                              maxHargaInput,
                                                          onChanged: (text) {
                                                            //Set value to slider
                                                            // _inputToSlider(
                                                            //     minHargaInput
                                                            //         .text,
                                                            //     text);
                                                          },
                                                          onSubmitted: (text) {
                                                            _inputToSlider(
                                                                minHargaInput
                                                                    .text,
                                                                text);
                                                          },
                                                          // onSubmitted: (_) =>
                                                          //     FocusScope.of(
                                                          //             context)
                                                          //         .nextFocus(),
                                                          decoration:
                                                              defaultInput(
                                                                  'Tertinggi',
                                                                  false)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30,
                                                child: RangeSlider(
                                                  values: _currentRangeValues,
                                                  min: 0,
                                                  max: 30000000,
                                                  divisions: 30000000,
                                                  labels: RangeLabels(
                                                    _currentRangeValues.start
                                                        .round()
                                                        .toString(),
                                                    _currentRangeValues.end
                                                        .round()
                                                        .toString(),
                                                  ),
                                                  onChanged:
                                                      (RangeValues values) {
                                                    setState(() {
                                                      //set max and min input from values range
                                                      minHargaInput.text =
                                                          values.start.toString();
                                                      maxHargaInput.text =
                                                          values.end.toString();
                                                      _currentRangeValues =
                                                          values;
                                                    });
                                                  },
                                                ),
                                              )
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            //footer
                            Container(
                              margin: EdgeInsets.only(top: sizeu.height - 150),
                              padding: EdgeInsets.only(top: 15, right: 20),
                              // alignment: Alignment.topRight,
                              height: 140,
                              width: sizeu.width,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                      height: 30,
                                      child: RaisedButton(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            side:
                                                BorderSide(color: Colors.green)),
                                        child: Text(
                                          'RESET',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.green),
                                        ),
                                        onPressed: () {
                                          _selectKategoriDetail = [];
                                          _selecteCategorys = [];
                                          _jenisProdukRadioButton = "semua";

                                          _currentRangeValues =
                                              RangeValues(0.0, 30000000);
                                          minHargaInput.text = '';
                                          maxHargaInput.text = '';

                                          setState(() {});
                                          // _closeEndDrawer();
                                        },
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(left: 10),
                                      height: 30,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          // side: BorderSide(color: Colors.green)
                                        ),
                                        color: Colors.green,
                                        child: Text(
                                          'SET',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.white),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          Future.delayed(Duration(seconds: 1),
                                              () {
                                            getData();
                                          });
                                          _closeEndDrawer();
                                        },
                                      ))
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(.2),
                                border: Border(
                                  top: BorderSide(
                                      width: .5,
                                      color: Colors.blueGrey.withOpacity(.2)),
                                ),
                              ),
                            ),
                          ],
                        ))),
            ),
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(60), child: headerSection()),
            body: isLoading
                ? reqLoad()
                : Column(
                    children: <Widget>[
                      Flexible(
                        child: getPopularCourseUI(),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  InputDecoration defaultInput(String hint, bool dis) {
    return new InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black54, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Colors.blueGrey.withOpacity(.2), width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Colors.blueGrey.withOpacity(.2), width: 1),
      ),
      hintText: hint,
      fillColor: dis ? Colors.grey.withOpacity(.2) : Colors.white,
      filled: true,
    );
  }

  Widget headerSection() {
    double topBarOpacity = 0.0;
    var sizeu = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 10),
      height: 110,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10),
            child: SizedBox(
              height: 40,
              width: sizeu.width - 48 - 10,
              child: TextField(
                onSubmitted: (value) {
                  print(value);
                  setState(() {
                    isLoading = true;
                  });
                  Future.delayed(Duration(seconds: 1), () {
                    getData();
                  });
                },
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
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  color: Colors.blueGrey,
                  icon: FaIcon(FontAwesomeIcons.funnelDollar),
                  tooltip: 'Filter',
                  onPressed: () {
                    _openEndDrawer();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget kategorifilter() {
    return Row(
      children: <Widget>[
        DropdownButtonHideUnderline(
          child: ButtonTheme(
            buttonColor: Colors.black,
            alignedDropdown: true,
            child: DropdownButton(
              value: dropdownValue,
              // icon: Icon(Icons.arrow_downward),
              //iconSize: 24,
              elevation: 16,
              hint: Text('--Kategori--'),
              style: TextStyle(color: FintnessAppTheme.green),
              underline: Container(
                height: 2,
                color: FintnessAppTheme.green,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: <String>[
                'Aksesoris Hewan Peliharaan',
                'Bahan & Bumbu Masak',
                'Buah & Sayur'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget priceBarFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Filter Harga',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        RangeSliderView(
          values: _values,
          onChangeRangeValues: (RangeValues values) {
            _values = values;
          },
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  //* Show List grid produk toko

  Widget getPopularCourseUI() {
    return Container(
      color: Colors.grey.withOpacity(.2),
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 18, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: gridProduk(),
            )
          ],
        ),
      ),
    );
  }

  Widget gridProduk() {
    final sizeu = MediaQuery.of(context).size;

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

      dataRown.add(Text(' ($jlmVote ulasan)',
          style: TextStyle(fontSize: 12, color: Colors.grey)));

      return Container(
          padding: EdgeInsets.only(top: 3), child: Row(children: dataRown));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: dataJson.length == 0
          ? dataKosong()
          : SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("geser ke atas untuk memuat");
                  } else if (mode == LoadStatus.loading) {
                    body = Text('Tunggu');
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Gagal dimuat!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: dataJson == null ? 0 : dataJson.length,
                itemBuilder: (BuildContext context, int i) => new SizedBox(
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, left: 1, right: 5, bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey.withOpacity(0.5),
                              //     spreadRadius: 1,
                              //     blurRadius: 7,
                              //     offset:
                              //         Offset(0, 3), // changes position of shadow
                              //   ),
                              // ],
                              ),
                          child: InkWell(
                            onTap: () {
                              // Navigate to the second screen using a named route.
                              // Navigator.pushNamed(context, '/produk');

                              _toProductDetail(
                                context,
                                dataJson[i]["id"].toString(),
                              );
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  //rubah gambar
                                  Container(
                                    height: (sizeu.width / 2)-5,
                                    decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                          image: NetworkImage(dataJson[i]
                                                  ["image_path"] ??
                                              'https://via.placeholder.com/300'),
                                          fit: BoxFit.cover),
                                      color: Colors.grey,
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(0),
                                        bottomLeft: Radius.circular(0),
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                    ),
                                  ),

                                  //konten
                                  Container(
                                    // padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                                    padding:
                                        EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    height: 110,
                                    decoration: BoxDecoration(
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
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            strutStyle:
                                                StrutStyle(fontSize: 12.0),
                                            text: TextSpan(
                                                style: TextStyle(
                                                    color: Colors.black),
                                                text:
                                                    '${dataJson[i]["nama"]}' ??
                                                        '-'),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 5),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            setHarga(dataJson[i]),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                          ),
                                        ),
                                         dataJson[i]['is_diskon'] == 1 ? 
                                        Row(
                                          children: [
                                            Card(
                                              color: Colors.red[100],
                                              child: Container(
                                                  margin: EdgeInsets.all(3),
                                                  child: Text(
                                                    '-' +
                                                        disconCondition(
                                                                dataJson[i])
                                                            .toString() +
                                                        '%',
                                                    style: TextStyle(
                                                      color: Colors.red[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 9,
                                                    ),
                                                  )),
                                            ),
                                            Text(
                                              beforeDisc(dataJson[i]),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ) : Container(),
                                        starJadi(
                                            double.parse(dataJson[i]
                                                    ['avg_ulasan']
                                                .toString()),
                                            dataJson[i]['count_ulasan']
                                                .toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 15, left: 10, right: 5, bottom: 16),
                        alignment: Alignment.topLeft,
                        child: Card(
                          color: Colors.green[100],
                          child: Container(
                              margin: EdgeInsets.all(3),
                              child: Text(
                                dataJson[i]["isGrosir"] == 1
                                    ? 'Grosir'
                                    : 'Retail',
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
                staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(2, 3.6),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              )),
    );
  }

  void moveTo() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => CourseInfoScreen(),
      ),
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = '';
    if (CategoryType.ui == categoryTypeData) {
      txt = 'Retail';
    } else if (CategoryType.coding == categoryTypeData) {
      txt = 'Grosir';
    } else if (CategoryType.basic == categoryTypeData) {
      txt = 'Lainnya';
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? FintnessAppTheme.green
                : DesignCourseAppTheme.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: FintnessAppTheme.green)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? DesignCourseAppTheme.nearlyWhite
                        : FintnessAppTheme.green,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor('#F8FAFB'),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: FintnessAppTheme.green,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Search for course',
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: HexColor('#B9BABC'),
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: HexColor('#B9BABC'),
                            ),
                          ),
                          onEditingComplete: () {},
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.search, color: HexColor('#B9BABC')),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }
}

enum CategoryType {
  ui,
  coding,
  basic,
}
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HeaderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double topBarOpacity = 0.0;
    TextEditingController editingController = TextEditingController();
    var sizeu = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 30),
      height: 110,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10),
            child: SizedBox(
              height: 40,
              width: sizeu.width - 48 - 10,
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
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  color: Colors.blueGrey,
                  icon: FaIcon(FontAwesomeIcons.funnelDollar),
                  tooltip: 'Filter',
                  onPressed: () {
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActorFilterEntry {
  const ActorFilterEntry(this.name, this.initials);
  final String name;
  final String initials;
}

class Products {
  int id;
  String name;
  String price;
  String star;
  String type;

  Products({this.id, this.name, this.price, this.star, this.type});
}
