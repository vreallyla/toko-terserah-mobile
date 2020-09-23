import 'package:best_flutter_ui_templates/fitness_app/produk_detail/galleryitem.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class GambarUlasan extends StatefulWidget {
  const GambarUlasan({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _GambarUlasanState createState() => _GambarUlasanState();
}

class _GambarUlasanState extends State<GambarUlasan> {
  @override
  Widget build(BuildContext context) {
    //final wh_ = MediaQuery.of(context).size;
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Foto dari Pembeli',
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
        body: Center(
          child: FutureBuilder<List<String>>(
            future: fetchGalleryData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.all(5),
                          child: InkWell(
                            onTap: () {
                              // Navigate to the second screen using a named route.
                              Navigator.pushNamed(
                                  context, GalleryItem.routeName,
                                  arguments:
                                      NetworkImage(snapshot.data[index]));
                            },
                            child: Container(
                                decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                        image: new NetworkImage(
                                            snapshot.data[index]),
                                        fit: BoxFit.cover))),
                          ));
                    });
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
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

Future<List<String>> fetchGalleryData() async {
  try {
    final response = await http
        .get(
            'https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/data.json')
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      return compute(parseGalleryData, response.body);
    } else {
      throw Exception('Failed to load');
    }
  } on SocketException catch (e) {
    throw Exception('Failed to load');
  }
}

List<String> parseGalleryData(String responseBody) {
  final parsed = List<String>.from(json.decode(responseBody));
  return parsed;
}
// end stack end
