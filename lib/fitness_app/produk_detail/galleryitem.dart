import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class GalleryItem extends StatelessWidget {
  static const routeName = '/lihatgambar';

  @override
  Widget build(BuildContext context) {
    final NetworkImage args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Simple Photo View'),
      ),
      body: PhotoView(
        imageProvider: args,
        // Contained = the smallest possible size to fit one dimension of the screen
        minScale: PhotoViewComputedScale.contained * 0.8,
        // Covered = the smallest possible size to fit the whole screen
        maxScale: PhotoViewComputedScale.covered * 2,
        enableRotation: true,
        // Set the background color to the "classic white"
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
        // loadingBuilder: Center(
        //   child: CircularProgressIndicator(),
        // ),
      ),
    );
  }
}
