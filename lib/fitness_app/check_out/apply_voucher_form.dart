import 'package:flutter/material.dart';

class ApplyVoucherForm extends StatefulWidget {
  const ApplyVoucherForm(
      {Key key, this.showing, this.dataVoucher, this.sendApi})
      : super(key: key);

  final bool showing;
  final Map<String, dynamic> dataVoucher;
  final Function(String kode) sendApi;

  @override
  _ApplyVoucherFormState createState() => _ApplyVoucherFormState();
}

class _ApplyVoucherFormState extends State<ApplyVoucherForm> {
  TextEditingController voucherInput = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return !widget.showing
        ? Text('',
            style: TextStyle(
              fontSize: 0,
            ))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.withOpacity(.4),
                ),
                margin: EdgeInsets.only(left: sizeu.width / 2 - 30, top: 10),
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                alignment: Alignment.topCenter,
                height: 140,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text('Punya kode voucher? masukkan di sini',
                            style: TextStyle(color: Colors.black54))),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: sizeu.width - 80 - 30,
                          height: 40,
                          child: TextField(
                            textAlign: TextAlign.left,
                            onChanged: (text) => {},
                            controller: voucherInput,
                            onSubmitted: (v) {
                              setState(() {
                                widget.sendApi(v);
                              });
                            },
                            decoration: new InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black54, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black38, width: 1),
                              ),
                              hintText: 'Masukkan kode voucher',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: SizedBox(
                            height: 40,
                            width: 75,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(4.0),
                                  bottomLeft: Radius.circular(4.0),
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.sendApi(voucherInput.text);
                                });
                              },
                              color: Colors.green,
                              child: Text(
                                'SET',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                   ( widget.dataVoucher != null
                        ? !(widget.dataVoucher.containsKey('caption') ||
                            widget.dataVoucher.containsKey('message'))
                        : true)
                            ? Text(
                                '',
                                style: TextStyle(fontSize: 0),
                              )
                            : Padding(
                                padding: EdgeInsets.fromLTRB(1, 10, 1, 1),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        color: widget.dataVoucher.containsKey('caption') ?Colors.green:Colors.red
                                        , fontSize: 15,),
                                    children: [
                                      TextSpan(
                                          text: widget.dataVoucher.containsKey('caption') ? widget.dataVoucher['caption']:widget.dataVoucher['message']),
                                      WidgetSpan(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: Icon(
                                           widget.dataVoucher.containsKey('caption') ? Icons.check_circle: Icons.remove_circle,
                                            color: widget.dataVoucher.containsKey('caption') ?Colors.green:Colors.red,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                  ],
                ),
              ),
            ],
          );
  }
}
