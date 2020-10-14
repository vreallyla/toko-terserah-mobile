import 'package:best_flutter_ui_templates/fitness_app/produk_detail/product_detail2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';

class DetailCardView extends StatefulWidget {
  final Map<String, dynamic> detailList;
  final String title;
  final bool moreText;

  const DetailCardView({
    Key key,
    this.detailList,
    this.title,
    this.moreText,
  }) : super(key: key);

  @override
  _DetailCardViewState createState() => _DetailCardViewState();
}

class _DetailCardViewState extends State<DetailCardView> {
  List<Widget> dataWidget = <Widget>[];

// print(widget.detailList);

  void addAllData() {
    dataWidget = [];
    //judul
    if (widget.title == 'Deskripsi') {
      dataWidget.add(
        Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: widget.detailList != null
              ? Text(widget.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ))
              : Container(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
                  height: 20,
                  width: 250,
                  color: Colors.blueGrey.withOpacity(.4),
                ),
        ),
      );
      dataWidget.add(
        widget.detailList != null
            ? Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Text(
                  widget.detailList['deskripsi'],
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.justify,
                  maxLines: 7,
                ),
              )
            : Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    height: 16,
                    width: double.infinity,
                    color: Colors.blueGrey.withOpacity(.4),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    height: 16,
                    width: double.infinity,
                    color: Colors.blueGrey.withOpacity(.4),
                  ),
                ],
              ),
      );
    } else {
      dataWidget.add(
        widget.detailList != null
            ? Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Html(
                  data: widget.detailList['detail'],

                  //Optional parameters:
                  style: {
                    "html": Style(
                      backgroundColor: Colors.white,
//              color: Colors.white,
                    ),
//            "h1": Style(
//              textAlign: TextAlign.center,
//            ),
                    "table": Style(
                      backgroundColor: Colors.white,
                    ),
                    "ul": Style(padding: EdgeInsets.all(0)),
                    "li": Style(
                      margin: EdgeInsets.all(0),
                      fontSize: FontSize(16),
                      textAlign: TextAlign.justify,
                    ),
                    "h2": Style(
                      fontSize: FontSize(20),
                    ),
                    "tr": Style(
                      border: Border(bottom: BorderSide(color: Colors.white)),
                    ),
                    "th": Style(
                      padding: EdgeInsets.all(6),
                      backgroundColor: Colors.white,
                    ),
                    "td": Style(
                      padding: EdgeInsets.all(6),
                    ),
                    "var": Style(fontFamily: 'serif'),
                  },
                  customRender: {
                    "flutter":
                        (RenderContext context, Widget child, attributes, _) {
                      return FlutterLogo(
                        style: (attributes['horizontal'] != null)
                            ? FlutterLogoStyle.horizontal
                            : FlutterLogoStyle.markOnly,
                        textColor: context.style.color,
                        size: context.style.fontSize.size * 5,
                      );
                    },
                  },
                  onLinkTap: (url) {
                    print("Opening $url...");
                  },
                  onImageTap: (src) {
                    print(src);
                  },
                  onImageError: (exception, stackTrace) {
                    print(exception);
                  },
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 20, 15, 15),
                    height: 20,
                    width: 250,
                    color: Colors.blueGrey.withOpacity(.4),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    height: 16,
                    width: double.infinity,
                    color: Colors.blueGrey.withOpacity(.4),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    height: 16,
                    width: double.infinity,
                    color: Colors.blueGrey.withOpacity(.4),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    height: 16,
                    width: double.infinity,
                    color: Colors.blueGrey.withOpacity(.4),
                  ),
                ],
              ),
      );
    }

    if (widget.moreText)
      dataWidget.add(
        Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(top: 15, bottom: 15),
          decoration: borderTop(),
          child: Text(
            'Baca Selengkapnya',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    addAllData();

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      width: size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: dataWidget,
      ),
    );
  }
}
