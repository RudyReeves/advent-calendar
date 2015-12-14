import 'dart:io' show File;

main() async {
  var floors = (await new File('inputs/day1_input.txt').readAsString()).split('');
  int floorChange(c) =>
    c == '(' ? 1 : (c == ')' ? -1 : 0);
  int floor = floors.fold(0, (prev, c) => prev + floorChange(c));
  print(floor);
}