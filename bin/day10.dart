final input = 1113122113;

lookAndSay(int n) {
  List<String> digits = n.toString().split('');
  var result = new StringBuffer();

  String currentDigit = digits.first;
  int count = 0;

  for (String digit in digits) {
    if (digit == currentDigit) {
      count++;
    } else {
      result.write('$count$currentDigit');
      currentDigit = digit;
      count = 1;
    }
  }
  result.write('$count$currentDigit');

  return int.parse('$result');
}

main() {
  int result = input;
  for (int i = 0; i < 40; i++) {
    result = lookAndSay(result);
  }
  print(result);
}