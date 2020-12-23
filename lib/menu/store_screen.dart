import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  _launchMap(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.grey[200],
        title: const Text(
          'Store',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.grey.withOpacity(.2),
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Toko Terserah',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text('Jl. Raya Lontar No. 46, Surabaya'),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    child: Text('Senin-Minggu | 09.00-21.00 WIB'),
                  ),
                  InkWell(
                    onTap: () => _launchMap('tel://+628113191081'),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                          child: FaIcon(
                            FontAwesomeIcons.phone,
                            color: Colors.green,
                            size: 14,
                          ),
                        ),
                        Text('  +62 811-3191-081',
                            style: TextStyle(color: Colors.green))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        _launchMap('whatsapp://send?phone=628113191081'),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 15,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                            child: FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.green,
                              size: 18,
                            ),
                          ),
                          Text(
                            '  +62 811-3191-081',
                            style: TextStyle(color: Colors.green),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () => _launchMap(
                            'https://www.google.com/maps/place/Toko+Terserah/@-7.2846996,112.6700155,17z/data=!3m1!4b1!4m5!3m4!1s0x2dd7fd512212f0cb:0x691f6e8fccb2aedd!8m2!3d-7.2846996!4d112.6722042'),
                        color: Colors.green,
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.mapMarkedAlt,
                              color: Colors.white,
                              size: 14,
                            ),
                            Text(
                              ' LIHAT PETA',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
