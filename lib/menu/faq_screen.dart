import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tokoterserah/Constant/Constant.dart';
import 'package:tokoterserah/menu/webview_menu.dart';

class FAQScreen extends StatefulWidget {
  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        leading: Transform.translate(
        offset: Offset(-5, 0),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
        brightness: Brightness.light,
        backgroundColor: Colors.grey[200],
        title: const Text(
          'FAQ',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          cardLink('Cara Belanja', globalBaseUrl + 'faq/cara_belanja'),
          cardLink('Cara Cek Order', globalBaseUrl + 'faq/cara_cek_order'),
          cardLink('Cara Daftar Akun', globalBaseUrl + 'faq/cara_daftar_akun'),
          cardLink(
              'Cara Ganti Password', globalBaseUrl + 'faq/cara_ganti_password'),
          cardLink('Cara Menggunakan Voucher',
              globalBaseUrl + 'faq/cara_menggunakan_voucher'),
          cardLink('Cara Mengubah Alamat',
              globalBaseUrl + 'faq/cara_mengubah_alamat'),
          cardLink(
              'Cara Menjadi Member', globalBaseUrl + 'faq/cara_menjadi_member'),
          cardLink(
              'Metode Pembayaran', globalBaseUrl + 'faq/metode_pembayaran'),
          cardLink('Syarat dan Ketentuan',
              globalBaseUrl + 'faq/syarat_dan_ketentuan'),
          cardLink('Tentang Kami', globalBaseUrl + 'faq/tentang_kami'),
        ],
      ),
    );
  }

  Widget cardLink(String name, String url) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebviewMenu(
                name: name,
                url: url,
              ),
            ));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: .5,
          color: Colors.grey,
        ))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width - 40 - 30,
              child: Text(
                name,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: 30,
              child: FaIcon(
                FontAwesomeIcons.chevronRight,
                color: Colors.grey,
                size: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
