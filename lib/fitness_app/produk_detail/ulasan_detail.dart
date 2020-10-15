import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/fitness_app/fintness_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:best_flutter_ui_templates/Constant/MathModify.dart';

class UlasanDetail extends StatefulWidget {
  final List<dynamic> dataReview;
  const UlasanDetail({Key key, this.animationController, this.dataReview})
      : super(key: key);

  final AnimationController animationController;
  @override
  _UlasanDetailState createState() => _UlasanDetailState();
}

CategoryType categoryType = CategoryType.lima;
enum CategoryType {
  lima,
  empat,
  tiga,
  dua,
  satu,
}

class _UlasanDetailState extends State<UlasanDetail> {
  Widget getCategoryUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 10.0, left: 1, right: 1, bottom: 10),
          child: Text(
            'Filter Penilaian : ',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 30,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              getButtonUI(CategoryType.lima, categoryType == CategoryType.lima),
              const SizedBox(
                width: 10,
              ),
              getButtonUI(
                  CategoryType.empat, categoryType == CategoryType.empat),
              const SizedBox(
                width: 10,
              ),
              getButtonUI(CategoryType.tiga, categoryType == CategoryType.tiga),
              const SizedBox(
                width: 10,
              ),
              getButtonUI(CategoryType.dua, categoryType == CategoryType.dua),
              const SizedBox(
                width: 10,
              ),
              getButtonUI(CategoryType.satu, categoryType == CategoryType.satu),
            ],
          ),
        )
      ],
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    double txt = 0;
    if (CategoryType.lima == categoryTypeData) {
      txt = 5;
    } else if (CategoryType.empat == categoryTypeData) {
      txt = 4;
    } else if (CategoryType.tiga == categoryTypeData) {
      txt = 3;
    } else if (CategoryType.dua == categoryTypeData) {
      txt = 2;
    } else if (CategoryType.satu == categoryTypeData) {
      txt = 1;
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
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 2, right: 2),
              child: Center(
                child: SmoothStarRating(
                    allowHalfRating: false,
                    onRated: (v) {},
                    starCount: 5,
                    rating: txt,
                    size: 11.0,
                    isReadOnly: true,
                    //fullRatedIconData: Icons.blur_off,
                    //halfRatedIconData: Icons.blur_on,
                    color: Colors.green,
                    borderColor: Colors.green,
                    spacing: 1.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    //final wh_ = MediaQuery.of(context).size;
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          brightness: Brightness.light,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Ulasan Dari Pembeli',
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
        body: Container(
          child: ListView(
            physics:  const BouncingScrollPhysics(),
            children: [
              Column(children: <Widget>[
                getCategoryUI(),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.dataReview.length == null
                        ? 0
                        : widget.dataReview.length,
                    itemBuilder: (context, i) {
                      return kontenRiview(context, size, i, widget.dataReview);
                    })
              ]),
            ],
          ),
        ));
  }
}

Widget kontenRiview(context, size ,i, data) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.only(top: 10),
        alignment: Alignment.bottomLeft,
        child: SmoothStarRating(
            allowHalfRating: false,
            onRated: (v) {},
            starCount: 5,
            rating: double.parse(data[i]['bintang']),
            size: 20.0,
            isReadOnly: true,
            //fullRatedIconData: Icons.blur_off,
            //halfRatedIconData: Icons.blur_on,
            color: Colors.green,
            borderColor: Colors.green,
            spacing: 0.0),
      ),
      Container(
        padding: EdgeInsets.only(top: 10),
        alignment: Alignment.bottomLeft,
        child: Text(
          '${data[i]['deskripsi']}',
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
              '${diffForhumans(DateTime.parse(data[i]['created_at']))} oleh ',
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
      Container(
        width: size.width,
        padding: EdgeInsets.fromLTRB(11, 0, 11, 15),
        child: Row(
          children: <Widget>[
            gambarReview(context),
            gambarReview(context),
          ],
        ),
      ),
      SizedBox(
        height: 30,
      ),
    ],
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
// end stack end
