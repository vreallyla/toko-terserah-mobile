import 'dart:core';

 diffForhumans(DateTime diffDate){
     final date2 = DateTime.now();
    final hari = date2.difference(diffDate).inDays;
    final jam = date2.difference(diffDate).inHours;
    final menit = date2.difference(diffDate).inMinutes;
    final detik = date2.difference(diffDate).inSeconds;
    String satu = 'Beberapa detik lalu';
    String dua = '< semenit lalu';
    String tiga = ' menit lalu';
    String empat = '< sejam lalu';
    String lima = ' jam yang lalu';
    String enam = '< sehari lalu';
    String tujuh = ' hari yang lalu';
    String delapan = ' minggu yang lalu';
    String sembilan = ' sebulan lalu';
    String sepuluh = '< setahun lalu';
    String sebelas = ' tahun yang lalu';
    String duabelas = '> 5 tahun';
    String diffForHumans;

    if (detik <= 30) {
      // detik
      diffForHumans=satu.toString();
    } else if (detik > 30 && detik <= 60) {
      // kurang 1 menit
      diffForHumans=dua.toString();
    } else if (menit <= 30) {
      // per menit
      diffForHumans=menit.toString()+tiga.toString();
    } else if (menit > 30 && menit <= 60) {
      // sebelum sejam
      diffForHumans=empat.toString();
    } else if (jam <= 12) {
      // per jam
      diffForHumans=jam.toString()+lima.toString();
    } else if (jam > 12 && jam <= 24) {
      // sebelum sehari
      diffForHumans=enam.toString();
    } else if (hari <= 6) {
      // per hari
      diffForHumans=hari.toString() + tujuh.toString();
    } else if (hari >= 6 && hari <= 30) {
      //perminggu
      diffForHumans=(hari / 7).round().toString() + delapan.toString();
    } else if (hari > 30 && hari <= 210) {
      //per bulan
      diffForHumans=(hari / 30).round().toString() + sembilan.toString();
    } else if (hari > 210 && hari <= 360) {
      // sebelum setahun
      diffForHumans=sepuluh.toString();
    } else if (hari >= 360 && hari <= 1800) {
      // pertahun
      diffForHumans=(hari / 30).round().toString() + sebelas.toString();
    } else if (hari >= 1800) {
      // lebih 5 tahun
      diffForHumans=duabelas.toString();
    }

    return  diffForHumans;
  }