import 'package:flutter/material.dart';

class FooterAppView extends StatefulWidget {
  @override
  _FooterAppViewState createState() => _FooterAppViewState();
}

class _FooterAppViewState extends State<FooterAppView> {
 bool rememberMe = false;

  void _onRememberMeChanged(bool newValue) => setState(() {
    rememberMe = newValue;

    if (rememberMe) {
      // TODO: Here goes your functionality that remembers the user.
    } else {
      // TODO: Forget the user
    }
    setState(() {
      
    });
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

     return PreferredSize(
      preferredSize: Size.fromHeight(80.0),
      child: BottomAppBar(
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width / 2 - 40,
              child: new Row(
                children: <Widget>[
                  Checkbox(
                   value: rememberMe,
      onChanged: _onRememberMeChanged,
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    tristate: false,
                  ),
                  Text(
                    'Pilih Semua',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            Container(
              width: size.width / 2 - 60,
              height: 70,
              padding: EdgeInsets.only(top: 15, bottom: 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Subtotal',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Rp15.000.000',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
            InkWell(
              onTap: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, '/checkout');
              },
              child: Container(
                height: 50,
                color: Colors.green[300],
                alignment: Alignment.center,
                width: 90,
                child: Text(
                  'CHECKOUT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  
  }
}