import 'package:flutter/material.dart';
import 'package:tokoterserah/Constant/expandeable_custom.dart';
import 'package:tokoterserah/Constant/Constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Ketentuan extends StatefulWidget {
  @override
  _KetentuanState createState() => _KetentuanState();
}

class _KetentuanState extends State<Ketentuan> {
  bool _pendahuluan = true,
      _logFile = true,
      _cookies = true,
      _privacy = true,
      _infoAnak = true,
      _online = true,
      _persetujuan = true;

  String _pendahuluanContent =
      'Syarat dan ketentuan ini menguraikan aturan dan peraturan untuk penggunaan Situs Web Toko Terserah, yang berlokasi di tokoterserah.com.Dengan mengakses situs web ini, kami menganggap Anda menerima syarat dan ketentuan ini. Jangan terus menggunakan Toko Terserah jika Anda tidak setuju untuk mengambil semua syarat dan ketentuan yang dinyatakan di halaman ini. Syarat dan Ketentuan kami dibuat dengan bantuan Syarat & Ketentuan Generator Online dan Generator Syarat & Ketentuan Gratis .';

  String _logFileContent =
      'Kami tidak akan bertanggung jawab atas konten apa pun yang muncul di Situs Web Anda. Anda setuju untuk melindungi dan membela kami terhadap semua klaim yang muncul di Situs Web Anda. Tidak ada tautan yang muncul di Situs web mana pun yang dapat ditafsirkan sebagai fitnah, cabul atau kriminal, atau yang melanggar, jika tidak melanggar, atau mengadvokasi pelanggaran atau pelanggaran lain terhadap, hak pihak ketiga.';

  String _cookiesContent =
      'Kami berhak meminta Anda menghapus semua tautan atau tautan tertentu apa pun ke Situs Web kami. Anda menyetujui untuk segera menghapus semua tautan ke Situs web kami berdasarkan permintaan. Kami juga berhak mengubah syarat dan ketentuan ini dan ini menautkan kebijakan kapan saja. Dengan terus menautkan ke Situs web kami, Anda setuju untuk terikat dan mengikuti syarat dan ketentuan tautan ini.';

  String _privacyContent =
      'Jika Anda menemukan tautan apa pun di Situs Web kami yang menyinggung karena alasan apa pun, Anda bebas untuk menghubungi dan memberi tahu kami kapan saja. Kami akan mempertimbangkan permintaan untuk menghapus tautan tetapi kami tidak berkewajiban atau lebih atau untuk menanggapi Anda secara langsung.Kami tidak memastikan bahwa informasi di situs web ini benar, kami tidak menjamin kelengkapan atau keakuratannya; kami juga tidak berjanji untuk memastikan bahwa situs web tetap tersedia atau bahwa materi di situs web tetap terbaru.';

  String _infoAnakContent =
      'Bagian lain dari prioritas kami adalah menambahkan perlindungan untuk anak-anak saat menggunakan internet. Kami mendorong orang tua dan wali untuk mengamati, berpartisipasi, dan / atau memantau dan membimbing aktivitas online mereka. Toko Terserah tidak sengaja mengumpulkan Informasi Identifikasi Pribadi apa pun dari anak di bawah 13 tahun. Jika Anda berpikir bahwa anak Anda memberikan informasi semacam ini di situs web kami, kami sangat menganjurkan Anda untuk menghubungi kami segera dan kami akan melakukan yang terbaik upaya untuk segera menghapus informasi tersebut dari catatan kami.';

  String _onlineContent =
      'Kebijakan Privasi ini hanya berlaku untuk aktivitas online kami dan berlaku untuk pengunjung situs web kami sehubungan dengan informasi yang mereka bagikan dan / atau kumpulkan di Toko Terserah. Kebijakan ini tidak berlaku untuk informasi apa pun yang dikumpulkan secara offline atau melalui saluran selain dari situs web ini.';

  String _persetujuanContent =
      'Dengan menggunakan situs web & aplikasi kami, Anda dengan ini menyetujui Kebijakan Privasi kami dan menyetujui Syarat dan Ketentuannya.';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double _width = size.width;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.grey[200],
          title: const Text(
            'Syarat & Ketentuan',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 15),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              pendahuluan(),
              logFile(),
              cookies(),
              privacy(),
             
            ],
          ),
        ));
  }

  Widget pendahuluan() {
    return ExpandableCustom(
      show: _pendahuluan,
      funcShowHide: (bool hideOrShow) {
        _pendahuluan = hideOrShow;
        setState(() {});
      },
      icon: FontAwesomeIcons.angleDown,
      head: Row(
        children: [
          Text(
            'Welcome',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      bodyHide: Text(
        '',
      ),
      bodyShow: SizedBox(
          child: Text(
        '${_pendahuluanContent}',
        textAlign: TextAlign.justify,
      )),
      useFooter: _pendahuluan,
      footer: SizedBox(),
    );
  }

  Widget logFile() {
    return ExpandableCustom(
      show: _logFile,
      funcShowHide: (bool hideOrShow) {
        _logFile = hideOrShow;
        setState(() {});
      },
      icon: FontAwesomeIcons.angleDown,
      head: Row(
        children: [
          Text(
            'Kewajiban',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      bodyHide: Text(
        '',
      ),
      bodyShow: SizedBox(
          child: Text(
        '${_logFileContent}',
        textAlign: TextAlign.justify,
      )),
      useFooter: _logFile,
      footer: SizedBox(),
    );
  }

  Widget cookies() {
    return ExpandableCustom(
      show: _cookies,
      funcShowHide: (bool hideOrShow) {
        _cookies = hideOrShow;
        setState(() {});
      },
      icon: FontAwesomeIcons.angleDown,
      head: Row(
        children: [
          Text(
            'REvervasi Hak',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      bodyHide: Text(
        '',
      ),
      bodyShow: SizedBox(
          child: Text(
        '${_cookiesContent}',
        textAlign: TextAlign.justify,
      )),
      useFooter: _cookies,
      footer: SizedBox(),
    );
  }

  Widget privacy() {
    return ExpandableCustom(
      show: _privacy,
      funcShowHide: (bool hideOrShow) {
        _privacy = hideOrShow;
        setState(() {});
      },
      icon: FontAwesomeIcons.angleDown,
      head: Row(
        children: [
          Text(
            'Penghapusan Tautan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      bodyHide: Text(
        '',
      ),
      bodyShow: SizedBox(
          child: Text(
        '${_privacyContent}',
        textAlign: TextAlign.justify,
      )),
      useFooter: _privacy,
      footer: SizedBox(),
    );
  }

  Widget infoAnak() {
    return ExpandableCustom(
      show: _infoAnak,
      funcShowHide: (bool hideOrShow) {
        _infoAnak = hideOrShow;
        setState(() {});
      },
      icon: FontAwesomeIcons.angleDown,
      head: Row(
        children: [
          Text(
            'Informasi Anak-Anak',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      bodyHide: Text(
        '',
      ),
      bodyShow: SizedBox(
          child: Text(
        '${_infoAnakContent}',
        textAlign: TextAlign.justify,
      )),
      useFooter: _infoAnak,
      footer: SizedBox(),
    );
  }

  Widget online() {
    return ExpandableCustom(
      show: _online,
      funcShowHide: (bool hideOrShow) {
        _online = hideOrShow;
        setState(() {});
      },
      icon: FontAwesomeIcons.angleDown,
      head: Row(
        children: [
          Text(
            'Kebijakan Infromasi Online',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      bodyHide: Text(
        '',
      ),
      bodyShow: SizedBox(
          child: Text(
        '${_onlineContent}',
        textAlign: TextAlign.justify,
      )),
      useFooter: _online,
      footer: SizedBox(),
    );
  }

  Widget persetujuan() {
    return ExpandableCustom(
      show: _persetujuan,
      funcShowHide: (bool hideOrShow) {
        _persetujuan = hideOrShow;
        setState(() {});
      },
      icon: FontAwesomeIcons.angleDown,
      head: Row(
        children: [
          Text(
            'Persetujuan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      bodyHide: Text(
        '',
      ),
      bodyShow: SizedBox(
          child: Text(
        '${_persetujuanContent}',
        textAlign: TextAlign.justify,
      )),
      useFooter: _persetujuan,
      footer: SizedBox(),
    );
  }
}
