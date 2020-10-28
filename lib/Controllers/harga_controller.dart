import 'package:intl/intl.dart';

setHarga(Map<String, dynamic> obj) {
  return withCurrency(obj['harga_grosir'] != null
      ? (obj['diskonGrosir'] != null
          ? obj['harga_diskon_grosir']
          : obj['harga_grosir'])
      : (obj['diskon'] != null ? obj['harga_diskon'] : obj['harga']));
}

setHargaWithQty(Map<String, dynamic> obj, double qty ) {
  double harga=nilaiDoubleHarga(obj);
  
  return withCurrency((harga*qty).toString());
  // return harga;
}

nilaiDoubleHarga(Map<String, dynamic> obj){
  return double.parse(obj['harga_grosir'] != null
      ? (obj['diskonGrosir'] != null
          ? obj['harga_diskon_grosir']
          : obj['harga_grosir'])
      : (obj['diskon'] != null ? obj['harga_diskon'] : obj['harga']));
}

minQty(Map<String, dynamic> obj){
  return int.parse(obj['min_qty'] != null ? obj['min_qty'] : '1');
}

setMinOrder(Map<String, dynamic> obj){
  int minnQty=minQty(obj);
  return double.parse(minnQty >int.parse(obj['stock']) ? obj['stock'] : minnQty.toString());
}

kondToCart(Map<String, dynamic> obj){
  return double.parse(minQty(obj).toString())>setMinOrder(obj);
}

disconCondition(Map<String, dynamic> obj) {
  return obj['isGrosir'] > 0
      ? (obj['isDiskonGrosir']>0?int.parse(obj['diskonGrosir']) :0 )
      : (obj['is_diskon']>0?int.parse(obj['diskon']) :0 );
}

beforeDisc(Map<String, dynamic> obj) {
  return disconCondition(obj) > 0
      ? withCurrency(obj['isGrosir'] > 0 ? obj['harga_grosir'] : obj['harga'])
      : 'Rp0,00';
}

withCurrency(String val) {
  var numberFormat = NumberFormat.currency(locale: "id_ID", symbol: "Rp");
  return numberFormat.format(double.parse(val));
}

isGrosir(Map<String, dynamic> obj) {
  return obj['isGrosir'] > 0 ? 'Grosir' : 'Retail';
}

pointGroup(int value) {
  return NumberFormat("#,###", "id_ID").format(value);
}

decimalPointOne(String value){
    return NumberFormat("#,##0.0", "id_ID").format(double.parse(value));
}

decimalPointTwo(double value) {
  return NumberFormat("#,##0.00", "id_ID").format(value);
}