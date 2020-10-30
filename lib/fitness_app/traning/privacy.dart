import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/Constant/expandeable_custom.dart';
import 'package:best_flutter_ui_templates/Constant/Constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  bool _pendahuluan = true,
      _logFile = true,
      _cookies = true,
      _privacy = true,
      _infoAnak = true,
      _online = true,
      _persetujuan = true;

  String _pendahuluanContent =
      'Di Toko Terserah, dapat diakses dari tokoterserah.com, salah satu prioritas utama kami adalah privasi pengunjung kami. Dokumen Kebijakan Privasi ini berisi jenis informasi yang dikumpulkan dan dicatat oleh Toko Terserah dan bagaimana kami menggunakannya. Jika Anda memiliki pertanyaan tambahan atau memerlukan informasi lebih lanjut tentang Kebijakan Privasi kami, jangan ragu untuk menghubungi kami.';

  String _logFileContent =
      'Toko Terserah mengikuti prosedur standar menggunakan file log. File-file ini mencatat pengunjung ketika mereka mengunjungi situs web. Semua perusahaan hosting melakukan ini dan bagian dari analisis layanan hosting. Informasi yang dikumpulkan oleh file log termasuk alamat protokol internet (IP), tipe browser, Penyedia Layanan Internet (ISP), cap tanggal dan waktu, halaman rujukan / keluar, dan mungkin jumlah klik. Ini tidak terkait dengan informasi apa pun yang dapat diidentifikasi secara pribadi. Tujuan dari informasi ini adalah untuk menganalisis tren, mengelola situs, melacak pergerakan pengguna di situs web, dan mengumpulkan informasi demografis.';

  String _cookiesContent =
      'Seperti situs web lainnya, Toko Terserah menggunakan cookies. Cookie ini digunakan untuk menyimpan informasi termasuk preferensi pengunjung, dan halaman-halaman di situs web yang diakses atau dikunjungi pengunjung. Informasi ini digunakan untuk mengoptimalkan pengalaman pengguna dengan menyesuaikan konten halaman web kami berdasarkan jenis browser pengunjung dan / atau informasi lainnya.';

  String _privacyContent =
      'Anda dapat berkonsultasi daftar ini untuk menemukan Kebijakan Privasi untuk masing-masing mitra iklan Toko Terserah. Kebijakan Privasi kami dibuat dengan bantuan Pembuat Kebijakan Privasi Gratis dan Pembuat Kebijakan Privasi Online . Server iklan pihak ketiga atau jaringan iklan menggunakan teknologi seperti cookie, JavaScript, atau Web Beacon yang digunakan dalam iklan masing-masing dan tautan yang muncul di Toko Terserah, yang dikirim langsung ke browser pengguna. Mereka secara otomatis menerima alamat IP Anda ketika ini terjadi. Teknologi ini digunakan untuk mengukur efektivitas kampanye iklan mereka dan / atau untuk mempersonalisasi konten iklan yang Anda lihat di situs web yang Anda kunjungi.Perhatikan bahwa Toko Terserah tidak memiliki akses ke atau kontrol terhadap cookie ini yang digunakan oleh pengiklan pihak ketiga.';

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
            'Kebijakan & Privasi',
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
              infoAnak(),
              online(),
              persetujuan()
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
            'PENDAHULUAN',
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
            'Log File',
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
            'Cookies',
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
            'Privasi',
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
