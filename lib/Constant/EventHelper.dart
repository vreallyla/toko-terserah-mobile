 zerofill(int nilai, int panjang){
  String parseString=(nilai).toString();
    int len=parseString.length;
    String zerofill='';

    for (var i = 0; i < (panjang - len ); i++) {
      zerofill=zerofill+'0';
    }

    return (zerofill+parseString);

}