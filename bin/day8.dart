import 'dart:io' show File;

main() async {
  List lines = await new File('inputs/day8_input.txt').readAsLines();
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
  print("Part 2: ${part2(lines)}");
}

part2(lines) {
  int count = 0;

  for (var line in lines) {
    int length = line.length;
    int escapeLength = length;
    line = line.replaceAll(r'\\', r'\"');
    var chars = line.split('');
    for (var char in chars) {
      if (char == '"') {
        escapeLength++;
      } else if (char == r'\') {
        escapeLength++;
      }
    }
    int difference = escapeLength - length + 2;
    count += difference;
  }

  return count;
}