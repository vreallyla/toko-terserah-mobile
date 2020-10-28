import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpandableCustom extends StatefulWidget {
  const ExpandableCustom(
      {Key key,
      this.show: false,
      this.useFooter: true,
      this.head,
      this.bodyShow,
      this.bodyHide,
      this.icon,
      this.funcShowHide,
      this.footer})
      : super(key: key);

  final bool show;
  final bool useFooter;
  final Widget head;
  final Widget bodyShow;
  final Widget bodyHide;
  final Widget footer;
  final Function(bool hideOrShow) funcShowHide;
  final icon;

  @override
  _ExpandableCustomState createState() => _ExpandableCustomState();
}

class _ExpandableCustomState extends State<ExpandableCustom> {
  Color animateColor = Colors.white;
  Color animateColorBtn = Colors.grey;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double _width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 1500),
            width: _width,
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            decoration: BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(width: 1.0, color: Colors.grey.withOpacity(.4)),
              ),
              color: animateColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: _width - 50, child: widget.head),
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.funcShowHide(!widget.show);

                      if (widget.show) {
                        animateColor = Colors.white;

                        animateColorBtn = Colors.grey;
                      } else {
                        animateColor = Colors.grey.withOpacity(.05);

                        animateColorBtn = Colors.green;
                      }
                    });
                  },
                  child: SizedBox(
                    width: 20,
                    child: FaIcon(
                      widget.icon != null
                          ? widget.icon
                          : (widget.show
                              ? FontAwesomeIcons.chevronUp
                              : FontAwesomeIcons.chevronDown),
                      color: animateColorBtn,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //body
          AnimatedContainer(
            duration: Duration(milliseconds: 1500),
            color: animateColor,
            width: _width,
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: widget.show ? widget.bodyShow : widget.bodyHide,
          ),
          //footer
          !widget.useFooter
              ? Text(
                  '',
                  style: TextStyle(fontSize: 0),
                )
              : Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          width: 1.0, color: Colors.grey.withOpacity(.4)),
                    ),
                  ),
                  child: widget.footer),
        ],
      ),
    );
  }
}
