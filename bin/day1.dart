import 'dart:io' show File;

main() async {
  var floors = (await new File('inputs/day1_input.txt').readAsString()).split('');
  int floorChange(c) =>
    c == '(' ? 1 : (c == ')' ? -1 : 0);
  int floor = floors.fold(0, (prev, c) => prev + floorChange(c));
  print(floor);
  print("Part2: ${part2(floors)}");
}

part2(floors) {
  int floor = 0;
  for (int i = 0; i < floors.length; i++) {
    if (floors[i] == '(') floor++;
    if (floors[i] == ')') floor--;
    if (floor < 0) return i + 1;
  }
}