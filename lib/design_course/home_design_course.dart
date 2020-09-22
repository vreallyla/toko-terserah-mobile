import 'package:best_flutter_ui_templates/design_course/course_info_screen.dart';
import 'package:best_flutter_ui_templates/design_course/popular_course_list_view.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/fitness_app/fintness_app_theme.dart';
import 'package:best_flutter_ui_templates/hotel_booking/range_slider_view.dart';

class DesignCourseHomeScreen extends StatefulWidget {
  @override
  _DesignCourseHomeScreenState createState() => _DesignCourseHomeScreenState();
}

class NewItem {
  bool isExpanded;
  String header;
  Widget body;
  Icon iconpic;
  NewItem(this.isExpanded, this.header, this.body, this.iconpic);
}

class _DesignCourseHomeScreenState extends State<DesignCourseHomeScreen> {
  CategoryType categoryType = CategoryType.ui;
  String dropdownValue;
  String subdropdownValue;
  TextEditingController editingController = TextEditingController();
  RangeValues _values = const RangeValues(100, 600);
  double distValue = 50.0;

  List<NewItem> items = <NewItem>[
    new NewItem(
        false, 'Filter dan Kategori', SizedBox(), new Icon(Icons.expand_more)),
    //give all your items here
  ];

  ListView listcriteria;
  @override
  Widget build(BuildContext context) {
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
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(40), child: HeaderPage()),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top / 90,
            ),
            // getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      //  getSearchBarUI(),
                      getCategoryUI(),

                      listcriteria,

                      //  priceBarFilter(),
                      Flexible(
                        child: getPopularCourseUI(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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

  Widget getCategoryUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 1.0, left: 18, right: 16),
          // child: Text(
          //   'Kategori dan Jenis Produk',
          //   textAlign: TextAlign.left,
          //   style: TextStyle(
          //     fontWeight: FontWeight.w600,
          //     fontSize: 22,
          //     letterSpacing: 0.27,
          //     color: DesignCourseAppTheme.darkerText,
          //   ),
          // ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[
              getButtonUI(CategoryType.ui, categoryType == CategoryType.ui),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.coding, categoryType == CategoryType.coding),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.basic, categoryType == CategoryType.basic),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        // CategoryListView(
        //   callBack: () {
        //     moveTo();
        //   },
        // ),
      ],
    );
  }

  Widget getPopularCourseUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   'Produk',
          //   textAlign: TextAlign.left,
          //   style: TextStyle(
          //     fontWeight: FontWeight.w600,
          //     fontSize: 22,
          //     letterSpacing: 0.27,
          //     color: DesignCourseAppTheme.darkerText,
          //   ),
          // ),
          Flexible(
            child: PopularCourseListView(
              callBack: () {
                moveTo();
              },
            ),
          )
        ],
      ),
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

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Choose your',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: DesignCourseAppTheme.grey,
                  ),
                ),
                Text(
                  'Design Course',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: DesignCourseAppTheme.darkerText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            child: Image.asset('assets/design_course/userImage.png'),
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
            padding: EdgeInsets.only(left: 12, right: 16, top: 0, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40,
                  width: 280,
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
                    left: 20,
                    right: 1,
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Icon(
                          Icons.notifications,
                          color: Colors.black,
                          size: 25,
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
              ],
            ),
          )
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
