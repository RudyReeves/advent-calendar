import 'dart:io' show File;

main() async {
  List strings = await new File('inputs/day5_input.txt').readAsLines();

  int niceStrings = 0;
  for (var string in strings) {
    if (string.isEmpty) continue;
    int numVowels = new RegExp(r'(a)|(e)|(i)|(o)|(u)').allMatches(string).length;
    bool reg2 = new RegExp(r'([a-z])\1').hasMatch(string);
    bool reg3 = !new RegExp(r'(ab)|(cd)|(pq)|(xy)').hasMatch(string);
    if (numVowels >= 3 && reg2 && reg3) {
      niceStrings++;
    }
  }
  print(niceStrings);
  print("Part 2: ${part2(strings)}");
}

part2(strings) {
  int niceStrings = 0;
  for (var string in strings) {
    if (string.isEmpty) continue;
    bool reg1 = new RegExp(r'([a-z]{2})[a-z]*\1').hasMatch(string);
    bool reg2 = new RegExp(r'([a-z])[a-z]\1').hasMatch(string);
    if (reg1 && reg2) {
      niceStrings++;
    }
  }
  return niceStrings;
}