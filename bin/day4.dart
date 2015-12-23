import 'package:crypto/crypto.dart' show CryptoUtils, MD5;

md5(String key) {
  var md5 = new MD5()..add(key.codeUnits);
  return CryptoUtils.bytesToHex(md5.close());
}

main(List args) {
  String secret = args[0];

  int n = 0;
  for (; true; n++) {
    String key = '$secret$n';
    var hash = md5(key).toString();
    if (hash.startsWith('00000')) {
      break;
    }
  }

  print(n);
  print("Part 2: ${part2(secret)}");
}

part2(secret) {
  for (int n = 0; true; n++) {
    String key = '$secret$n';
    var hash = md5(key).toString();
    if (hash.startsWith('000000')) {
      return n;
    }
  }
}