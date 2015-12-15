import 'dart:io';

main() async {
  List lines = await new File('inputs/day8_input.txt').readAsLines();
//  var lines = [r'xziq\\\x18ybyv\x9am\"neacoqjzytertisysza'];
  int count = 0;

  for (var line in lines) {
    line = line.replaceAll(r'\\', r'\"');
    int length = line.length;
    int escapedLength = length;

    var parts = line.split(r'\');
    for (int i = 1; i < parts.length; i++) {
      var part = parts[i];
      if (part.startsWith('"')) {
        escapedLength--;
      } else if (part.startsWith('x')) {
        escapedLength -= 3;
      }
    }

    int difference = length - escapedLength + 2;
    count += difference;
  }
  print(count);
}