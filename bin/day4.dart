import 'package:crypto/crypto.dart';

main(List args) {
  String secret = args[0];

  for (int n = 0; true; n++) {
    String key = '$secret$n';
    var hash = md5(key).toString();
    if (hash.startsWith('00000')) {
      print(n);
      return;
    }
  }
}

md5(String key) {
  var md5 = new MD5()..add(key.codeUnits);
  return CryptoUtils.bytesToHex(md5.close());
}