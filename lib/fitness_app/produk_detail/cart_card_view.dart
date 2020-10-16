import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:best_flutter_ui_templates/Controllers/harga_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardCardView extends StatelessWidget {
  const CardCardView({Key key, this.dataProduct, this.getPcs}) : super(key: key);

  final Map<String, dynamic> dataProduct;
  final Function(int value) getPcs;


  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    // getPcs(setMinOrder(dataProduct).round());

    return Container(
      height: sizeu.width / 2 - sizeu.width / 15,
      padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: sizeu.width / 4 / 1.5,
                  width: sizeu.width / 4 / 1.5,
                  margin: EdgeInsets.only(top:20),
                  child: Image.network(
                    globalBaseUrl +
                        locationProductImage +
                        dataProduct['gambar'],
                    fit: BoxFit.cover,
                    width: sizeu.width / 4 / 1.5,
                    height: sizeu.width / 4 / 1.5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:20),

                  height: (sizeu.width / 3) + 15,
                  width: sizeu.width - sizeu.width / 4 / 1.5 - 20 - 100 - 30+68,
                  // color: Colors.red,
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        width: sizeu.width - 50 - sizeu.width / 4 - 10,
                        child: Text(
                          dataProduct['nama'],
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Card(
                            color: Colors.green[100],
                            child: Container(
                                margin: EdgeInsets.all(2),
                                child: Text(
                                  isGrosir(dataProduct),
                                  style: TextStyle(
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                )),
                          ),
                          Card(
                            color: Colors.blue[100],
                            child: Container(
                                margin: EdgeInsets.all(2),
                                child: Text(
                                  (dataProduct['stock'] + ' pcs'),
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        width: sizeu.width - 50 - sizeu.width / 4 - 10,
                        child: Text(
                          setHarga(dataProduct),
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        width: sizeu.width - 50 - sizeu.width / 4 - 10,
                        child: Text(
                          'Minimal ' + pointGroup(minQty(dataProduct)) + ' Pcs',
                          maxLines: 1,
                          style:
                              TextStyle(fontSize: 13, color: Colors.blueGrey),
                        ),
                      ),
                      
                        SpinBox(
                          min: setMinOrder(dataProduct),
                          max: double.parse(dataProduct['stock']),
                          value: setMinOrder(dataProduct),
                          onChanged: (value) {
                            // print(int.parse(value.toString()));
                            getPcs(value.round());
                          },
                        ),
                     
                   
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: FaIcon(FontAwesomeIcons.times,color: Colors.grey.withOpacity(.8),)),
                )
              ]),
       
        ],
      ),
    );
  }
}
